Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5569222576
	for <linux-trace-devel@vger.kernel.org>; Thu, 27 Feb 2025 20:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740688041; cv=none; b=SLePq2XGAIMAydE9KjUeGmdl0MWPwwm7tihq+vdTFZ/ife/krRgatE1ngwb8abB6XAfVA2xaI8iJikkbaa5sVazLNfOUOPb/t/jsGSZZKFk2cd4k4stYr/LBdGabw28wxxKUUZFK4+MZDtk1MDrkkoYpQMzinM8ygNLCMEMfHGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740688041; c=relaxed/simple;
	bh=7bePtJnKdpCWc+FH4tGEljJxgtsDe4WRabjcJt5AHg8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GMKFJ7BZa0AThdD+tHh4bS4aE+5Wyq5VF1sO3hw2VzwUbodkd/1/HDncghC8tXk4Q32Y6nWlD54HuCPS0EBjpiai2/xL1jhIgYjqzvIYEdqXb6ngylzJFv3KfYutosRW8IjxH7ZVgM8F6+SzNRFzu+Cc6lWwiBYhfP2OMgpWmao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C6oNZ2Qe; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C6oNZ2Qe"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-390df942558so1024298f8f.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Feb 2025 12:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740688038; x=1741292838; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wqtcCtnUuyMhR0SPqECg0i3NTA02eIM2y8g6/CV6P6c=;
        b=C6oNZ2QeqdJUqbgon3eKzqSeWUOzKK0JOSpYpWbHRNVSqT6tOubYBt2W81vUq9HzbK
         +H3Rx1BYDG4oxBR9czS99jMMJWlUPBp4vlhLxCEzE/Q+4LqrPerdI1EDWApNfOm5EPKA
         2QE36mZv4JkZKTnnVjlJBOiQCs4lJ1VTRkMhuO0RRRW1LZXFjOsirjnfcff6guv/GRa7
         NBTbQ1Kz1BKr5oy5fJI+fUwQULedTHE70wOwOX+EqvrVG/lVTnTMQE2/o+aN9AEzhP7J
         L7LR0kBNMuQ309NRD5IQjzhzUnBWlXrvmxlgF2PWAbOsGanhT0JJdp8eS1bXGQjVzsWh
         Hf6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740688038; x=1741292838;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wqtcCtnUuyMhR0SPqECg0i3NTA02eIM2y8g6/CV6P6c=;
        b=tiE58MyHroRMWP5RIgZNZLD3IndKmkYDH0lxhF8pqB+2/01Tf0sQoEmoUrQPV4m6Bn
         AA/RFYtb18BEfiufQJMVFyMEG3JcGDpFIG9boGAs9lK3jtADf7G/ssSJ0r9dam66os74
         33ZLDeF7neCWY60ANvphQegNQ2ULoQSDfmz6Vij8DEX/IgLgvTUiLW3kqS460k23Q3YM
         /FL28xlA1gfbgrH8mKvIiJBKhV8z115H9bC6UOayDMzAhjk0AqM5pksS3YyOyVisTCeZ
         /Ii3vZXRF1rKkZdy52c0sDlgZZJLJ73q+8VtgxEw6y5tpbBxvA1qR+xpALtkv6zeW9Gt
         zSJA==
X-Gm-Message-State: AOJu0YxFMUnaXYV2913842pDOIZbhAx1j93+8rMoK18rALsmlRYFaNtT
	y8HtW0awP4uzGmHeBYlRQTXy/B4z/0k9dYmyqzb23+tMA7KkM5Go/5qCImac
X-Gm-Gg: ASbGnctp/z7b3gUSssZktb9Oe92T9/zrZHJNlScdVxEOVjLr0DgMyERX4Xb6VOqbvgH
	53g+jiZEgR3wmyoZmkWxNGZxm1qNv5lLc1I4tfRhGHpqjQ7gh5PPLE0kaXnLnDhPni4MR3bNsxa
	25qeSSRp7w2nDP46EJuBh50ZBbeOjulzN01YxLryroZJASQUXP+9E6rPtq2oc/0R6sh4YkCARnH
	jV0uLOqsQwW5BWumzH0PH2TzYA2iCUgJTIGLIshsohFw+G1ME7O5kguwdanFw3pz1H1LWeDBrIt
	/w6aOygMNBKlnFNGzOs6wIu+mzz8PTZYIZrTMgOJ/2Vo
X-Google-Smtp-Source: AGHT+IEctkHis5Vv1L/R2cUtv9z+sWs1L4Z8Zsukn2h3EZz0n6X5ddv8Kaz/8AG8U4vgvkvfHF/shg==
X-Received: by 2002:a05:6000:2cb:b0:38f:513a:e12c with SMTP id ffacd0b85a97d-390eca637bamr539795f8f.45.1740688037563;
        Thu, 27 Feb 2025 12:27:17 -0800 (PST)
Received: from localhost.localdomain ([2a02:a03f:e6d8:fc01:121f:74ff:fe57:106])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e485df22sm3101793f8f.97.2025.02.27.12.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 12:27:17 -0800 (PST)
From: Ruben Devos <devosruben6@gmail.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org,
	Ruben Devos <devosruben6@gmail.com>
Subject: [PATCH] libtraceevent: Add support for \t char in print fmt
Date: Thu, 27 Feb 2025 21:26:18 +0100
Message-ID: <20250227202618.54073-1-devosruben6@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Events can have \t characters in their print format strings. An example
is the smb3_cmd_done event from the cifs module. It has print format
string:
	 "\tsid=0x%llx tid=0x%x cmd=%u mid=%llu", ...

Add \t as an accepted character in the while loop that parses the format
string. This prevents the "[FAILED TO PARSE]" message and imporperly
parsed output in `trace-cmd report`.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219688
Signed-off-by: Ruben Devos <devosruben6@gmail.com>
---
 src/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index f2e50b0..06dfd52 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -1307,7 +1307,7 @@ static enum tep_event_type __read_token(struct tep_handle *tep, char **tok)
 			/* Break out if the file is corrupted and giving non print chars */
 			if (ch <= 0)
 				break;
-		} while ((ch != quote_ch && isprint(ch)) || last_ch == '\\' || ch == '\n');
+		} while ((ch != quote_ch && isprint(ch)) || last_ch == '\\' || ch == '\n' || ch == '\t');
 		/* remove the last quote */
 		i--;
 
-- 
2.48.1

