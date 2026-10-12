// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Starcrossed — zodiac compatibility readings sealed on BOT Chain
/// @notice For entertainment only. No tokens, no payments, no admin, no personal data.
contract Starcrossed {
    struct Reading {
        address creator;
        uint8 signA;
        uint8 signB;
        uint8 score;
        uint64 timestamp;
    }

    Reading[] public readings;
    mapping(address => uint256[]) private _readingsOf;

    /// @dev 12x12 symmetric score table (0-100), row = signA, column = signB.
    ///      Signs are 0 = Aries ... 11 = Pisces.
    bytes constant TABLE =
        hex"492d4f2b5f2b42245c2c542b"
        hex"2d4934522a5a224b295d294d"
        hex"4f344c334d2c582741266129"
        hex"2b523352354b26592445265d"
        hex"5f2a4d35502f4c2e5d244129"
        hex"2b5a2c4b2f512c502e59274b"
        hex"422258264c2c4a2c4c265822"
        hex"244b27592e502c512f4b2c5a"
        hex"5c2941245d2e4c2f50354d2a"
        hex"2c5d26452459264b35523352"
        hex"542961264127582c4d334c34"
        hex"2b4d295d294b225a2a523449";

    event ReadingSealed(
        uint256 indexed id,
        address indexed creator,
        uint8 signA,
        uint8 signB,
        uint8 score
    );

    /// @notice Seal a reading for two signs. The score is computed on-chain.
    function seal(uint8 signA, uint8 signB) external returns (uint256 id) {
        uint8 score = compatibility(signA, signB);
        id = readings.length;
        readings.push(Reading(msg.sender, signA, signB, score, uint64(block.timestamp)));
        _readingsOf[msg.sender].push(id);
        emit ReadingSealed(id, msg.sender, signA, signB, score);
    }

    function getReading(uint256 id) external view returns (Reading memory) {
        require(id < readings.length, "Reading not found");
        return readings[id];
    }

    function readingsOf(address user) external view returns (uint256[] memory) {
        return _readingsOf[user];
    }

    function totalReadings() external view returns (uint256) {
        return readings.length;
    }

    /// @notice Free preview of the score for a pair of signs.
    function compatibility(uint8 a, uint8 b) public pure returns (uint8) {
        require(a < 12 && b < 12, "Invalid sign");
        return uint8(TABLE[uint256(a) * 12 + b]);
    }
}
