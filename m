Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792738560;
	b=ezqX+ttn75EBwRXpTsrDnSIfdQw/k9J8ZURucyGc7bXaRRXPRh6vYyucABQnvLOVXnGQ
	 c2P43Z9B4k7lozCfpfyeOCwHXEtyjF6ugpIBIT25FFZkE6QJWozzZairKG+9aTdkPgPio
	 49edxeHL94qUuNSqrNy2qOdPKkwy4atItn8y3oGGMLm/ikjQxf70Xj7l2NA7CYT9UKabq
	 Bi09iTrjkZ2TDsBELPWbZAfffk6x1iWvWUA05j0K/l5JpwbPpeX61EdxKN31+BDOWCdYD
	 rMxMV9xf6gV59KIPC66EHavbRXTfqqPGiJTp5DeFnhs2gRVmHaO4xDJ3wJOU7ku5aNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792738560;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XVFKtMclflxu84xCB2HKA9EO/Mn4sdFSGF7EjkJB7ZI=;
	b=SRzaaT68bS/G4cJd2eHtHjMUQe8LczzNbfmE4OlrMdZoRaF7rzAuCYD3EhDN3m9mkGOx
	 qFiHrE42fWHM43lWhay8H5cSzS9qhDK8VPbBRXPQpeDXkLS7nBjYXrmQU87qHzJTWHwlE
	 lVNEG8+Pi3KJi1Q/0xcaWzRSNpoFpws0Ay8l+oRTx4hZZkMgsfEnsojFKvN3j24ySCJqS
	 MNiCWzBpdLiFIwOjyTtY5uIpsijUlna7C6yuKLIqALRQz/6l2t7YqHk0YARGrZ0I/bWUg
	 ozIiVCJKbIISX72RVnGgJU7guGK05SMoWI9bZo2Ps6o+B+ADuTIvdBZFb86vHC+nBIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=hBZ7WBUm;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23233606A31A
	for <linux-trace-devel@vger.kernel.org>; Fri, 23 Oct 2026 06:55:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23233606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=hBZ7WBUm
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-398b3c37877so339897a91.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Oct 2026 23:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792738559; x=1793343359; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XVFKtMclflxu84xCB2HKA9EO/Mn4sdFSGF7EjkJB7ZI=;
        b=hBZ7WBUm7D5RCbpRr1LZXraeLP8GJBWSIXQ5NjWtQL/yAkNTHhCKMwbJ3garibdwZp
         IigpaG3F2VmLzhW2SEy8hSHhojhuWdi71sDc6oADlfP+vzWCPHKhYYQkAesuZeMRymZx
         yskkqZCf6mxLh0wt86MPf+zdkoG/onyojICZf2R+5Eaw1xZr8b6vAEncvVtVOn6k5w72
         wJwM3pM7q1tTTYokjXrO+a8v9DLxjaEM6nDCDKlI6fuK7dYQeq8WQwdyIBBUMi73V3sz
         CswDD/ss7NiKUd903Q2/vJJxnmftzCO/fiAsUy4LUw+0cKD0ccLjveQXSpquAuylJA9m
         rFUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792738559; x=1793343359;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XVFKtMclflxu84xCB2HKA9EO/Mn4sdFSGF7EjkJB7ZI=;
        b=H+J1CK5z6QfyR3AN8ZDts55q/Va7YYCLmAgEndWL67qKGgXerq9ktBYD2JKCK1P4TZ
         R1FL5rWX96IJEDo5TWFRx96tk9LQvamlOOzQo8X3Rynx/A1mtYGvYgx0H4UixdbNgrrL
         p9jxgg1go3yGssNcK+JutvEeyXHLcVe50A+oFaq1iez+6QA+lMKNWcZPUeQXjWGCK66y
         Xk5Uv9q3+CCWKLMrwIDoHLffp2d8yu8ReH3LTTAdKkHHZ6Qv4eFbyQV5ZY3PHXFAJDxc
         dePHPX9PcBq5IiQWXDSHX182rFgQwGkxkZqeaVcHEqx4TWpZumOl7P8/i2bfVo9MQaEn
         9Gdg==
X-Gm-Message-State: AFq9FYIcRGfi+uQAB4wpSxd8vF8dfohhQuF73MuLsFxkUrYPFFV1XbTB
	/oS9hfSI+BleiNyY7OyHApeoUFlCbBDIsgjffTrBHnpvvERqG8e3wmvWljLMqatA
X-Gm-Gg: AYBFou1DFuwBStWnZCrrRy13r5q8TdExjlOJV20i7hZdD5oTeDz2Cwpv0ghP5f+5h2L
	9nuhshqTt4/pt4YZQwjXxrEesoEhlMhIjKWB6SKkG5yPBgHAXBuA8i3yHpNopJ0pZyb+7Pq4rGq
	UJ4qvX2quJadVIqaxkk43Yo0ZCZRWVRuviizrBARgqUl0O6I8Q2+jzoWMls8vs/CK9fwEGs8C8d
	JVEfuLlJMkeQ51uod61ROIiLp/+G7Cuxl8WjcpYOjjO8xLpOAVencEmZlV3YFkKsamJHhhbQbDI
	v2EV171gND7A/PQ/60Q5zqMAY3RPhbE1DADd8xNiWW2PcfT/MU6a1EPv+8Yg5xhEZGAFafKEECy
	6GFcIaipVy9Cm/gtIO60rhlIaKTLS8bwWhEU0JaZ4cP9UeqmvFAKROoJrn8K7Bau7z9Z1TU17Qy
	M0iREMWrwSEwAK77KTKZXzNzM5fyztEpju9Hn3zjon7GvWHiGIj2PwKM+iGldu5ZFHxLh9VjDZ2
	p2tU7kt4G66b1YpMw8XclbyS7pvFaF0Mvg0a4+Jf2TKI+OnnMNX8860mEWFbedmn83dqL1nQfcB
	8lT0kL5kP/rZ06bd13hO
X-Received: by 2002:a17:90b:1808:b0:3ac:4e18:237c with SMTP id 98e67ed59e1d1-3adcd7b565dmr1067292a91.0.1792738559271;
        Thu, 22 Oct 2026 23:55:59 -0700 (PDT)
Received: from lipengfei28-ThinkStation-P368.mioffice.cn ([2408:8607:1b00:8:c2fb:ae00:7ac4:b4a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada49544f1sm7478078a91.16.2026.10.22.23.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 23:55:58 -0700 (PDT)
From: Li Pengfei <ljdlns1987@gmail.com>
X-Google-Original-From: Li Pengfei <lipengfei28@xiaomi.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
	lipengfei28@xiaomi.com
Subject: [PATCH] libtracecmd: Pass the file name to the warning in tracecmd_write_cpu_data()
Date: Fri, 23 Oct 2026 14:55:28 +0800
Message-Id: <20261023065528.2702469-1-lipengfei28@xiaomi.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tracecmd_write_cpu_data() passes the file descriptor to a "%s"
conversion when the open fails, so the warning reads a negative int as a
pointer and crashes instead of naming the file that could not be read.

Pass the file name, which is what the message asks for.

Fixes: 65e6e60f6a7e ("trace-cmd library: Refactor the logic for writing trace data in the file")
Signed-off-by: Li Pengfei <lipengfei28@xiaomi.com>
---
 lib/trace-cmd/trace-output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 3ef6db6b..2b5607bf 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2876,7 +2876,7 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 		}
 		data[i].fd = open(cpu_data_files[i], O_RDONLY);
 		if (data[i].fd < 0) {
-			tracecmd_warning("Can't read '%s'", data[i].fd);
+			tracecmd_warning("Can't read '%s'", cpu_data_files[i]);
 			break;
 		}
 
-- 
2.34.1

