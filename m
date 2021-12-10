Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48802C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240222AbhLJLJF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240281AbhLJLJA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:09:00 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA16C0617A2
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:25 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id z5so29250955edd.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b4pWi4A2vvWE4/gD76knLe7GQI/kOC32ie15Oae6/rI=;
        b=SjP/o+Mq6C+aY3GR2GB0V90jB9pBKGP6ZnYjiTXCSCMY94TRZ7IEIcvZxZ0h+i/yT2
         tfM4uoDi06OqeS9wK76L9IFr32YPdxIE/xPa5+LewNJBj1Sx5/WOoPMSVV6x2iTYzVIL
         4QW6zdhdfLYzsbMdnDSh4TPOuH9FTiE5qxAhR+PFXS8bwdl6aDxbYUMDn5im81qHU0Rf
         TL0JoEt4+0FidxLiWkAyyzA/+Liw+gacnZBYocBxLMBxRvJEhQcY6GpcmBGFcoY7Ezgx
         SpBG1ZfZqvNsa9RQjYBCzbMRXBSTCGt/7dIlkEzPyfzwCnPav6Dz2Ia0kqdMSG7dmrfq
         YFwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b4pWi4A2vvWE4/gD76knLe7GQI/kOC32ie15Oae6/rI=;
        b=4X0a6pYQYhW0q0vaPy5T0wBKkGCw7cKh5fHxP+OEmoULgQGqNIjBVejaLxyOnEcPaJ
         z693i3RcpS/SfJKlElr8D94JCd1xSPJz5Wv5O38oxvpiE0EAkiSZmORqAQxskr4eLRei
         QhNnCmH92cojCOdXv/OvbFqi3YB1R4OkX0V43/JJTYXHXU7TuvVGGi/6/1J3cwpdjbha
         vyCJgzlCxzWAl5a1cnK5tNmUJYhc4G5X0zv5gqRmJJyG8XVEqqDAm+XX5gjX3+wznmhP
         HAAdi0xyZBAZIrGquPCz5Zvqur8UoCVVOw2lWjwj5G4EiRXiiSXXHBCjZVxVvhpMffw8
         EFAw==
X-Gm-Message-State: AOAM533XEaEDXEQyEDQg2gl/QXJ15/0Ia7gVz9eG7G6tCoQ2a9paHiFt
        DDBRDQSODWTGNCEYzMn15G4GI1rIsZ4=
X-Google-Smtp-Source: ABdhPJzN2AjQeO5bvBduu0ggEDBGePhsTkSkCYpOxU8JqtIUySzRz24tVTfEkGRYfM5TuPbX7/YEQA==
X-Received: by 2002:aa7:c415:: with SMTP id j21mr36937924edq.289.1639134324111;
        Fri, 10 Dec 2021 03:05:24 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gs17sm1278887ejc.28.2021.12.10.03.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:05:23 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 11/11] trace-cmd dump: Align better the output of flyrecord dump
Date:   Fri, 10 Dec 2021 13:05:11 +0200
Message-Id: <20211210110511.98856-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110511.98856-1-tz.stoyanov@gmail.com>
References: <20211210110511.98856-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The flyrecord dump prints various file offsets and sizes, that can be
huge numbers. Add format arguments to align better the output.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 907ebc90..dd627c4f 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -959,7 +959,7 @@ static void dump_flyrecord(int fd)
 			die("cannot read the cpu %d offset", i);
 		if (read_file_number(fd, &cpu_size, 8))
 			die("cannot read the cpu %d size", i);
-		do_print(FLYRECORD, "\t\t %lld %lld\t[offset, size of cpu %d]\n",
+		do_print(FLYRECORD, "\t %10.lld %10.lld\t[offset, size of cpu %d]\n",
 			 cpu_offset, cpu_size, i);
 	}
 	dump_clock(fd);
-- 
2.33.1

