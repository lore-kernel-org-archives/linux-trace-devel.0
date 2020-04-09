Return-Path: <SRS0=lsLa=5Z=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 079E2C2BA2B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C55102072F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K0V1I7tg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgDIN2k (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Apr 2020 09:28:40 -0400
Received: from mail-lf1-f53.google.com ([209.85.167.53]:45944 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgDIN2j (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 09:28:39 -0400
Received: by mail-lf1-f53.google.com with SMTP id f8so7855839lfe.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Apr 2020 06:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aeZW49DU0ZTK2YDnVcVQAVfucWFwMJK/34BSMcT3ih4=;
        b=K0V1I7tg8Rj9C9gOShZpeFpUYRNXfbMFmx56EALPMqQ9hd4f0iy5FtDcc470mvmEi/
         ZLCet0rZU6eJpmuxZitgFCufICF3JL/wAIPa+Iyv/uTfaAs8EvsFH/lehywwg/S7ggHF
         MfM6tlnCLa/s6fM1HCmsQESxej+mo888+Id6e1I2uOq04Kyl56HYh35tTya0KYriBY3F
         Onl0Y0SJiZ2er4dOhXkaeuiVIv0EVLMsrP9E+ZqJNe4XQPPI96PUtFeJJNbu0vxQjMWy
         fYFQVqnjX4qFTrBhwuVU3kFqFmSA046htesAt17o9d9ObeW/hNmd37Fl6FCf8bhP/2IH
         Kfgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aeZW49DU0ZTK2YDnVcVQAVfucWFwMJK/34BSMcT3ih4=;
        b=n17yUE/t6O4OOG4Prb9BXc4O+RHZG+sYQrRE65CdqyVJMLJSwfmreL1yOiMNjqZBIi
         9dsb2y6tV6xDey81TV6/gyOSgiXeCVABRMDkxuFwf+bT2+oHfqY7fNk04LP01ulLNIIl
         3NnNBp8Hnb0wyal+y9BmT5cicf6n05rXYUSX+XFYycRckEVCBxsl6uZgP9nwrijyh8DG
         kL0tw3YYWFP4zjZbAHh4q7FyrxsEDq9Eoq6ey5C/f0Zjqpi9/Nn/6R4DAg2bNvIQJqav
         Ny2stlNkzPIyd7sc6PYNzmxKiYTFiufBv0zn7TwREY0ojN+MBSi6faRO/3GFBhhDG97v
         +mSA==
X-Gm-Message-State: AGi0PuYhpu2z0WDE0NLdAfQxzs8DihJiGAZAdMUH//HD6r+pXqV0b9sh
        FkntmApOI7tAj5NRj8T40j0=
X-Google-Smtp-Source: APiQypLbZ/hbQ3bb0+0C/yE6tvc9mOjn1jDJfaiF8d8JJcbiu1MWI77wFAqt02+taMcgt20x2O5QEQ==
X-Received: by 2002:ac2:5109:: with SMTP id q9mr7624837lfb.145.1586438918293;
        Thu, 09 Apr 2020 06:28:38 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 13sm15210345ljq.68.2020.04.09.06.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 06:28:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Useful APIs for merging tracing files 
Date:   Thu,  9 Apr 2020 16:28:33 +0300
Message-Id: <20200409132835.79530-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Helper APIs, used when opening and merging files from same tracing
session.

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Add new API tracecmd_set_merge_peer()
  trace-cmd: Validate input parameters of tracecmd_get_guest_cpumap()
    API

 include/trace-cmd/trace-cmd.h |  2 +
 lib/trace-cmd/trace-input.c   | 71 +++++++++++++++++++++++++++++++----
 2 files changed, 66 insertions(+), 7 deletions(-)

-- 
2.25.1

