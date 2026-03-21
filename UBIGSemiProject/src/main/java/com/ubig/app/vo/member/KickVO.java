package com.ubig.app.vo.member;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder
public class KickVO {
	private int kickNo;//	KICK_NO	NUMBER
	private String kicker;//	KICKER	VARCHAR2(30 BYTE)
	private String kickedUser;//	KICKED_USER	VARCHAR2(30 BYTE)
}
