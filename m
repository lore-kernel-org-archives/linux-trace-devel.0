Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFAC1E863
	for <linux-trace-devel@vger.kernel.org>; Sun, 10 Mar 2024 19:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710099203; cv=none; b=WDASVCOZKIepzGTYIFBUl930e35Kp9vsDXjzpqf692YC+z4ROD2eFRNoxRIVJA56DWZ5/G6mr3FEd2eZmTuaEbfI5/7dmrvHou81sndYi12fWpagUg1jLDmOq4bfxinsERvbHc2LYfww5yYXnToe0zYz6eTELVN/j3Np4zLILEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710099203; c=relaxed/simple;
	bh=JrKLovrgj6g1SvF7bgktbHuYiKGg2LdjqBuD6r6OOrA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rrTeCjpoV8mEpO7O5Cq1ediK6UwGCLTKPR4gsA5Z3gwULg69bUtyNLs/Ft3PRL8k4UGfCOazop2uIcpQliv5rzsMi/9qLijqujnCaH2ZNXXv2L6NVFrhh1T8ROaOdU31KYdPPb1ySVez+c0z0ikS590f/aA2xg5ljYIDZkMx5w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vf6pVq2l; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vf6pVq2l"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4132a2d22bcso844335e9.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 10 Mar 2024 12:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710099199; x=1710703999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wmujne4kllNtJmiQzdYlILPsUBkqPYCk/Cxe5P6Y27o=;
        b=Vf6pVq2lIcv6aUwSyG60gZ0X0im+LGYLhyYqP33WTuUcz1Ye/a9nUvxw2qQwmuo23d
         h5j6QDeiqVqzSp0kyGzibQmbEfaIRAvXkdoDD5QLxSf9Koks4rbonFaws2SAjzh2hgrO
         jALrl0ZPcTE+nnUVeWbK4Kqn+FkhwGAx7l1aC/0fIQZnKnp3nHq4+cSLztN98/dUZ5LJ
         P43UUBhji/FzJjxCcwTu5AZra5PVbxu6X7/JV0G0/FFbkA7Rc5zoIGJQ3+bXs+FXc+9a
         Kdi6cH19SjpjZrLyuPst4iyKyuTGtZL+yUcaHqIxiBmyW+nXnX2tFm1nXeYxyy8yRYrK
         ifmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710099199; x=1710703999;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wmujne4kllNtJmiQzdYlILPsUBkqPYCk/Cxe5P6Y27o=;
        b=BLWk+LIMyzUpF0afXX58G7HXiycGUCpMBrpxvmiDm6ho3xAFQHZwlWP7Gd27FVhh3e
         3L+50W038Ybu/lxLLpq0nh/HcRReeoUC7TfvKmyHCFYYkD5b/d/ICmh3EIjphc0gE4Ok
         P+ysGxS8XKTedWf0PEenUa+1/hpp+1FJN6MHiXRTGjo5ZHg5KJjoE4Sh+10+rij/FsLP
         iNGbSk9sPG4fSAHb6NaL1PZLwLryDFM64uaeA1KAXoKUAkSvHWrrnPK1EcLXFa91zXp4
         eNFdg7xjmAQNM1Jqn2cpaCUjRGUucmsY6rOUAnpz5bcwVaSbZrxLgrnVzTEo5VaQ372E
         dtzQ==
X-Gm-Message-State: AOJu0YzI1nZ4qS3THY6OKF2B6VhDwngCRtd0ng5abt8Y+bH8JzqnIqhK
	0oD9FlSJYMzHGHQ+h8qqRis2ob+mLy7R8H6972heDfjxBqDw35uRblX6EzoT
X-Google-Smtp-Source: AGHT+IGG3K4tTNKeP9VNhUBzIEKwtCL411QbFqDf/rOdRQdYNqvnuQZUL/+Wdt4fvLQsITD2Mn1auQ==
X-Received: by 2002:a05:600c:4508:b0:413:2a10:8a29 with SMTP id t8-20020a05600c450800b004132a108a29mr514222wmo.13.1710099199044;
        Sun, 10 Mar 2024 12:33:19 -0700 (PDT)
Received: from belmeken.. (83-228-63-4.ip.btc-net.bg. [83.228.63.4])
        by smtp.gmail.com with ESMTPSA id ay5-20020a05600c1e0500b0041327ac5dbesm2422768wmb.48.2024.03.10.12.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Mar 2024 12:33:18 -0700 (PDT)
From: Yordan Karadzhov <y.karadz@gmail.com>
To: linux-trace-devel@vger.kernel.org
Cc: dev@benjarobin.fr,
	Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 1/3] kernel-shark: Enable extra compile warnings
Date: Sun, 10 Mar 2024 21:32:56 +0200
Message-ID: <20240310193258.50899-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here we just add "-Wextra" compiler flag. The warnings will be fixed
in following patches.

Signed-off-by: Yordan Karadzhov <y.karadz@gmail.com>
---
 CMakeLists.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 57bce29..a9bc082 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -81,8 +81,8 @@ find_package (Boost COMPONENTS unit_test_framework)
 set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
 set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
 
-set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -pthread -fPIC -fno-common")
-set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -pthread -fPIC -fno-common")
+set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -Wextra -pthread -fPIC -fno-common")
+set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -pthread -fPIC -fno-common")
 
 set(CMAKE_CXX_STANDARD 17)
 set(CMAKE_CXX_STANDARD_REQUIRED ON)
-- 
2.42.0

