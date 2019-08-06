Return-Path: <SRS0=jb6J=WC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0873DC433FF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Aug 2019 06:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1D842147A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Aug 2019 06:00:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UoxO5kVm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731675AbfHFGAF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Aug 2019 02:00:05 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46810 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfHFGAF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 02:00:05 -0400
Received: by mail-pg1-f196.google.com with SMTP id w3so3767500pgt.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Aug 2019 23:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U3h8rkbh3Hw1JDBb/1it64clMv89Qdi7H2J0QuNsMLs=;
        b=UoxO5kVmxBVTq485bor1IL6RtlbGgHQiDTlnC+Q3/2e3nOaqAkW/eVO1oZqBpkBpwI
         S6wyHqV4mImvXo9m5+iLOMCuLmMtrfcoROflHjRbvW95lIKTOcFDiYrSZldL/xQmLsdj
         p/U1GJ5BeNInXEAU6aPvy1dxoRnbDXEU9xzOaxV8zApLfnoN0kulxhUXkalGw+l5yojH
         QPAF5F8fLAFMkDhP9aIfpY7s7uEWF2scAHrB6ObipKaN4ieDZpGkNfoLjMx7+hpwTCtZ
         WUuL7h5wk5A8WCN802ad1NPWwq3x3jIV/79/Db6S+SPud0b79DSbp+bkPRy0aJWbjvZm
         sZsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U3h8rkbh3Hw1JDBb/1it64clMv89Qdi7H2J0QuNsMLs=;
        b=FgM7dlEm1zVtOycaWQZwpTXiRCK3uSlBq7usNVO2euTrR/cTGp3+/2AuuzC2KzKNYU
         TAnKqP8/6k3o3+zDVqqpMTzXtV1aqY4b02oZQSyN0LhiB9//KLVCkCxAZUD6+NCWgQ8e
         Y9CjbzneZDHPLpjsQTNDFMbOotJwlZG49eQB+gCx4JVwOIDcrTCTzbJSehzrih5MBOdH
         DC9er8Cnb+ZdU+OYjZutuKs2pFMLhhcgBA5/DNnrHIzen62+2j3AIkvYJMA221sFLfXz
         MNhVVhdr9L7TIhowbpbVJ6uqIKwWgy7I8wGODO+vW8JI3FXtpqFAOMFaHFO5RwkpPYlG
         sjBw==
X-Gm-Message-State: APjAAAXJSYPcKuhlDkc9tZZyvZCVE0+LH0oeZHm6NUhNzvP+CKNlDqtt
        RiWPKtHJpc0cOxicBIT5NPMvuTF7
X-Google-Smtp-Source: APXvYqypu1BT1o7ehYIn77Zwwc9PJLbxuk9rf8QGVqEzkE18fa61/E0TlhjOWENy5QhP5lpmEtJVow==
X-Received: by 2002:a17:90a:c20e:: with SMTP id e14mr1520127pjt.0.1565071204981;
        Mon, 05 Aug 2019 23:00:04 -0700 (PDT)
Received: from localhost.localdomain ([175.223.3.169])
        by smtp.gmail.com with ESMTPSA id ev3sm19934057pjb.3.2019.08.05.23.00.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 23:00:04 -0700 (PDT)
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
X-Google-Original-From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH 2/2] makefile: fix python SyntaxError
Date:   Tue,  6 Aug 2019 14:59:50 +0900
Message-Id: <20190806055950.23842-3-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190806055950.23842-1-sergey.senozhatsky@gmail.com>
References: <20190806055950.23842-1-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

  File "<string>", line 1
    import distutils.sysconfig; print distutils.sysconfig.get_config_var('LINKFORSHARED')
                                              ^
SyntaxError: invalid syntax

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index acf99b8..b1264d1 100644
--- a/Makefile
+++ b/Makefile
@@ -499,7 +499,7 @@ clean:
 
 PYTHON_INCLUDES = `python-config --includes`
 PYTHON_LDFLAGS = `python-config --ldflags` \
-		$(shell python -c "import distutils.sysconfig; print distutils.sysconfig.get_config_var('LINKFORSHARED')")
+		$(shell python -c "import distutils.sysconfig; print(distutils.sysconfig.get_config_var('LINKFORSHARED'))")
 PYGTK_CFLAGS = `pkg-config --cflags pygtk-2.0`
 
 ctracecmd.so: $(TCMD_LIB_OBJS) ctracecmd.i
-- 
2.22.0

