Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E17A2A8C7
	for <linux-trace-devel@vger.kernel.org>; Tue,  7 Nov 2023 22:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smile-fr.20230601.gappssmtp.com header.i=@smile-fr.20230601.gappssmtp.com header.b="1FV+hSWy"
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B24D11C
	for <linux-trace-devel@vger.kernel.org>; Tue,  7 Nov 2023 14:33:07 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-40839807e82so1019755e9.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Nov 2023 14:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile-fr.20230601.gappssmtp.com; s=20230601; t=1699396385; x=1700001185; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cgJyOMZZeBdJH1Xou73gegM/w1x/25Pjj9ShslfxkgY=;
        b=1FV+hSWyHmobRlKu5l4gyLYmWCO2RuWLChRBUDn4TGyqZs29fIpQmVT6SSThi2KXdN
         xCmqc/9qWeV1thqVKDZzuOv5NscMIX9yBO9F4puw/CknHwWtFWYdZdG2LJKtN+xFpJ5B
         hsQSErYQieDDgDl4Yyh0RS0/8YRh85+gPKmfbpiNM1h6nKmMI9rTKdl4OmB0r1sYDkcl
         TElOS+2CitwLdTamcD0/EW2PL8GTVYO27GeVR5ZwjJaw53cIV5TSajKBVxV7ShDTrs/V
         /MR+BuHlfpDHkwDnk/4xjZtPn1TZqk46Dx/wig5vPldHCH9nQDOKIm525xQAaznvXSCw
         38AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699396385; x=1700001185;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cgJyOMZZeBdJH1Xou73gegM/w1x/25Pjj9ShslfxkgY=;
        b=huyAG5zXPciZ5unWPB1DjUX5hFZ9WfYP4txr3hVKdYDSFK2ZV3766rL57syvXsZBvC
         fgmGAJpiQLDcosZE925neBf066kUh/ZJ3YGXn30YLSuvtZ43k96FhR9IO/B4glyBz2yH
         Ql6JZO33Sb+pkvcXgmmN3zE1yf2nIutWPCtl4xkXfT5oaIWpjHf6CtwhJly5XLLuWb5X
         eAidXwnvQUOLG7I1OZGncDt6GkwQA5Z2RsNQHwT2006ezVX9VOYQR9fitN1RFBVeNxJu
         s6az0GU08E9TW2bG6GZv51lkrcxyjMz8zA5w6cTF7CfaZW+dRv5JS2pvnfnBWO66Q1G7
         jCGw==
X-Gm-Message-State: AOJu0Yyo7EUcxaJK3/y+UhJ2Be8iqTkZ+AjnerBrFagW0HIOGFJcr44J
	hCKc3Qew4CHXQCiqgOXm21sDcX/B6DA54Zst9b8=
X-Google-Smtp-Source: AGHT+IFRRnnwtwVojTwvTpVSCC1qYwdqJqEeorp5z76CV6g9vyEOMqldkmpd6ZM0WJwAUzvJOgGFhA==
X-Received: by 2002:a05:600c:45c6:b0:3ff:516b:5c4c with SMTP id s6-20020a05600c45c600b003ff516b5c4cmr107793wmo.18.1699396385005;
        Tue, 07 Nov 2023 14:33:05 -0800 (PST)
Received: from P-ASN-ECS-830T8C3.numericable.fr ([89.159.1.53])
        by smtp.gmail.com with ESMTPSA id p12-20020a05600c358c00b003fe61c33df5sm17252303wmq.3.2023.11.07.14.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 14:33:04 -0800 (PST)
From: Yoann Congal <yoann.congal@smile.fr>
To: linux-trace-devel@vger.kernel.org
Cc: Yoann Congal <yoann.congal@smile.fr>
Subject: [PATCH] trace cmd record: Remove extra characters in documentation
Date: Tue,  7 Nov 2023 23:32:44 +0100
Message-Id: <20231107223244.1121582-1-yoann.congal@smile.fr>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In --tsync-interval option documentation, remove extra characters that
should not be there.

Signed-off-by: Yoann Congal <yoann.congal@smile.fr>
---
 Documentation/trace-cmd/trace-cmd-record.1.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index b709e483..cebe2a0b 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -363,9 +363,9 @@ OPTIONS
 *--tsync-interval*::
     Set the loop interval, in ms, for timestamps synchronization with guests:
         If a negative number is specified, timestamps synchronization is disabled
-        If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
+        If 0 is specified, no loop is performed - timestamps offset is calculated only twice,
         at the beginning and at the end of the trace.
-        Timestamps synchronization with guests works only if there is support for VSOCK.\n"
+        Timestamps synchronization with guests works only if there is support for VSOCK.
 
 *--tsc2nsec*::
     Convert the current clock to nanoseconds, using tsc multiplier and shift from the Linux
-- 
2.30.2

