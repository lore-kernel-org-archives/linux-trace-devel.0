Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733311365
	for <linux-trace-devel@vger.kernel.org>; Sat, 16 Dec 2023 01:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=footclan.ninja
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=footclan.ninja
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=footclan-ninja.20230601.gappssmtp.com header.i=@footclan-ninja.20230601.gappssmtp.com header.b="XaA27GM4"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-35f418f394dso5351205ab.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Dec 2023 17:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=footclan-ninja.20230601.gappssmtp.com; s=20230601; t=1702691776; x=1703296576; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=91fBruOuapOo1ftMQnRdgaELav9Ro3S6hl7/UmHpWs8=;
        b=XaA27GM4C0wTJuE1ymHn2n1aFgmm0/g1ACFGW2enNtvV+8g2iO3kt/j6NRr4dziEj2
         degVrx8MfzNo/VWGynnRuHcWlDTuXA8sVDgd4Ddbfm85lcXBxMtwK+BLNbye8EXhohGQ
         lsIpH0dMeDOLzaB9qxQH9A2mGbJ+You6MxQMn/1jJcOpb3DNzyNzmdr+BFW5/Txg5ZVe
         KQj8grclAWZ4wzS4IqOpPQlvOCbEsdo871cIBXzAbv+ioiRXZr5BkZfyJrla9GVmqmuf
         +DN+5bSorlRoFuf/CaKBZkJt04fS7ePwXQUNhOrUunfRhuk56Gx4fpb58Vd5EXYJkmR3
         9Lxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702691776; x=1703296576;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=91fBruOuapOo1ftMQnRdgaELav9Ro3S6hl7/UmHpWs8=;
        b=sAdgbDlCHjExGLa874SbO7eNO7xInIe7keW2WK93I8hm1CrJ0a+0sGCSTFwjqBArc0
         6Di+Warjc3R6myeuR+MLzljPNBz6ug3FKh4gfKk3++sBdc6CJrkodfv1skCLf5bbe2m1
         gbQciy8wfG2rNZN0lXZyLMm9HQLwcaohQaORDQYZHwk06XVdlzQkuz2y4ahEE8sN9Q3b
         LuZJtXQrhisaQLaGSa+utV+Y7GRIRONLt7o4QhfS90PCUBQm44vTCnElf5MLRB5lCN6h
         C4fePnR/WQNoRMHRAmxY9Jp5bqgAyVQngHV6HLwvg0Wh2wM0plHcO9JDdatG0KYUUnxp
         olbg==
X-Gm-Message-State: AOJu0Yyk5jzi3qTECh4/rYiUFEm2OjZVg+f4EEmL9YnANUAP1ypqkpH4
	JVg6R+zgUGr4Yypgm6paM0PZNMuNZLMr/YcXJsmWsgU4rujReB5sqBrcLifjjr4reC1apIzddjt
	zjw9L5lkQmp+Z1tJpQ2iN5UjgeWy35ZkCHJ04HH66oLB8/X4becK7RmRV0aGhzgVGF9uE1rwrI/
	k1wYsJXTZ9dubPahB9w+Exdxrq
X-Google-Smtp-Source: AGHT+IHECJrbcQ5VxnFBVDMpKZ/S0XLvExZRMPcRunj68OsqOy69ELLDJifmuI4MEujxxa/JT5+I1Q==
X-Received: by 2002:a05:6e02:320f:b0:35f:847c:1e5b with SMTP id cd15-20020a056e02320f00b0035f847c1e5bmr4409043ilb.53.1702691776437;
        Fri, 15 Dec 2023 17:56:16 -0800 (PST)
Received: from monolith.infra.footclan.ninja (2403-580c-b8e6-2--1d94.ip6.aussiebb.net. [2403:580c:b8e6:2::1d94])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902cece00b001d0c37a9ccdsm14897493plg.10.2023.12.15.17.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Dec 2023 17:56:16 -0800 (PST)
From: Matt Jolly <Matt.Jolly@footclan.ninja>
To: linux-trace-devel@vger.kernel.org
Cc: Matt Jolly <Matt.Jolly@footclan.ninja>
Subject: [PATCH] Bump meson version to >=0.58.0
Date: Sat, 16 Dec 2023 11:55:27 +1000
Message-ID: <20231216015527.167415-1-Matt.Jolly@footclan.ninja>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

plugins uses str.replace which was introduced in 0.58.0.

Signed-off-by: Matt Jolly <Matt.Jolly@footclan.ninja>
---
 meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/meson.build b/meson.build
index b61c873..34d3e6d 100644
--- a/meson.build
+++ b/meson.build
@@ -4,7 +4,7 @@
 
 project(
     'libtraceevent', ['c'],
-    meson_version: '>= 0.50.0',
+    meson_version: '>= 0.58.0',
     license: 'LGPL-2.1',
     version: '1.7.3',
     default_options: [
-- 
2.42.0

