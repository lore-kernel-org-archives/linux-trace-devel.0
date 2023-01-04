Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBDBDC46467
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Jan 2023 23:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbjADXy1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 18:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234496AbjADXy0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 18:54:26 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9ACBE0C
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 15:54:26 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 36so23409783pgp.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 04 Jan 2023 15:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XsEKwgZwsHZJ7Y/905ciaIE1WDacEVgdZUYdFUfzeYM=;
        b=D4P3vQITREvwZEf5YeIYelzrpgJdsE9h6+qqb5ZlTkmDtKW0+5BUl8bw9yqVyHUiuz
         yXh7EHtVZX5UPr448013vQYuZcL7g4bsuncEiQ8QHdPcPAQ2iLfNvyQ8JUMBrFoqTMZe
         cOeNDKgLswfgWt9cisAQurRPGI3lGhDCIsjVEsufOSGqAMxSP5ftuPBqjBrL/FuU9wdx
         7UqJ2uN1p0B/Hksskss6PexoteACTRWPNJ2VfZyYdxE26766hNDGeSB1TLBn0pzCvQfC
         oKYd4+V9RsSFcXZiOP6n/YVtRgNQr2ZpikI4FdV5hDN3tr/sb4VrlSWEeXSgcHsOs//3
         9joA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XsEKwgZwsHZJ7Y/905ciaIE1WDacEVgdZUYdFUfzeYM=;
        b=TXfApThoYMGcLVp4Vjk+e7BkbyI/pEchkih0ImLy5r72YOL1GdbODzHjLsp8ns/dbS
         ABYX4padLGXXLbGjhjukzRyeUrJ17gbySZ5dOJ8VJPD4qPEus5HlCuePLZzgmW0KZHZZ
         eAUmSZDjS6Spjmd34QBwgLEuxkpxCm59v4dAOx/lhjMlFz4Y7wFE4/VjP4y0m26Cx7tk
         sbnYfUn9blr28rc2DlMRMGLQgib3bCGpRFzTzSbtaCWPIa2Gp3+ID5jSgsZgWVQ4/giv
         umrKqm4WsUkPG7+U940WeTCa+5plddUKP/fK3/CEy/HWaue2JAs1cFcEoE+1HZh14p7D
         JlDQ==
X-Gm-Message-State: AFqh2kpm2ZF33XvoJ5p54H8kSvGEXk6kqD/ch2zj+Y4/GdxJQgIoSIsr
        V0w6QL8111ASlZEID+QuiAj3VgVJcL4=
X-Google-Smtp-Source: AMrXdXtZKxMzTSbei6Ik21CeTMkEVG72/9KJOCqnjp4k4SLpYpqXgQxqte9y4BIqFsDecT6Q0GCmIg==
X-Received: by 2002:a05:6a00:781:b0:57f:d5d1:41d0 with SMTP id g1-20020a056a00078100b0057fd5d141d0mr11609555pfu.3.1672876465160;
        Wed, 04 Jan 2023 15:54:25 -0800 (PST)
Received: from mail.google.com (125-237-37-88-fibre.sparkbb.co.nz. [125.237.37.88])
        by smtp.gmail.com with ESMTPSA id e10-20020aa7980a000000b0056d98e31439sm13545297pfl.140.2023.01.04.15.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 15:54:24 -0800 (PST)
Date:   Thu, 5 Jan 2023 12:54:20 +1300
From:   Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     paulo.miguel.almeida.rodenas@gmail.com
Subject: [PATCH] trace-cmd: fix makefile cscope target
Message-ID: <Y7YRrHaV+V6v+9WZ@mail.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

existing cscope target using sh pipes was broken and cscope was throwing
the following error:

	$ make cscope
	[..]
	cscope: no source files found

fix cscope target by writing files to be indexed into a separate file
called cscope.files which cscope reads by default

Signed-off-by: Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
---
 Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 5a350b6..8c2496c 100644
--- a/Makefile
+++ b/Makefile
@@ -485,7 +485,8 @@ TAGS:	force
 
 cscope: force
 	$(RM) cscope*
-	$(call find_tag_files) | cscope -b -q
+	$(call find_tag_files) > cscope.files
+	cscope -b -q -f cscope.out
 
 install_plugins_tracecmd: force
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd/plugins install_plugins
-- 
2.38.1

