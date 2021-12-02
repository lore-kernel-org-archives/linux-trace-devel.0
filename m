Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B75C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346595AbhLBMed (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239614AbhLBMec (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:34:32 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A51C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:31:10 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id t5so115517217edd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CNckp9oPSnaKdqhV8asx+KNrp26gr5is0ypUgrnQUik=;
        b=OARA+Hx3nisTH54ieee8Kf1H0zYMOMFE2X9hQ+SDEt+tTvnXFhGTHP6shA4UZYfPL/
         IJQvM+4C1R50pJKeSyVrY5XQpkM7bB0/o4Hc27mcRr+SRqvU3qDL8JfsU0+exDsAwEYi
         an/+RlJ7rNBUMYhexetpOxDv5oT9GoycgwRaiwvDuZ507Wt6OkxTj5k+Wqxk3PHeEXbK
         aKSW992Naw1eNoYo4HL+uduQUfxGdzW2oTdJcn2A++Zs5c+DNG5/qAcMDstEAQeVx/eD
         g7btNv0pjDZfZMmWLmTMYojagb7rvZDioqS2AiGP+aN0yMLje2pglp0KjNR8J4DId2/w
         2hdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CNckp9oPSnaKdqhV8asx+KNrp26gr5is0ypUgrnQUik=;
        b=4Z3U1cseksJ93l7Fr+Ahe1XTEpQQbbt4dmx2ekZfe+hogJGHuZvbohN9ud92uQqb8O
         duGPs8iv7PC93L7cjPVofRodlNLXTwJhAmzpzmNUBIFGiTGxJLyIgKrrAKkqluM8qMy5
         cXpqlhF6ZbAYeCCfZoVm/+FphiJIwF3KEhhjptPKb89wns/Y0F6PNCFzVq7U2g21+vae
         /iECVyzZXLKN0YrhLKHerr8pZ3Z91zcQ7PFiPCnNzpyhNLOZuYrDeVRh4e31VVncWibA
         7RwyrWDUXXtC8y+4XbXwKvJ6+8vKDP1r1/Z2ewseMccDohJKztNM+dtQ0bGpA2Xq306U
         VZcg==
X-Gm-Message-State: AOAM5310uokOlTHL0fXX6WDs/Oq8AbrD/lLtEGLVn2Vl6ll7cGVIB7GG
        MbLjlPIHG3K3I8xyBMmbHWdXWBochszouQ==
X-Google-Smtp-Source: ABdhPJx7MjUUJ1mEWmpOZ1O3JdItjU6xL1dyJrCY1MMI4AxpzkwFVXonfpCXmQp7ik5EUjoT6tTP6g==
X-Received: by 2002:a17:906:1558:: with SMTP id c24mr15596480ejd.553.1638448268632;
        Thu, 02 Dec 2021 04:31:08 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b14sm2120394edw.6.2021.12.02.04.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:31:08 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 0/4] trace-cmd documentation update for v7 files
Date:   Thu,  2 Dec 2021 14:31:02 +0200
Message-Id: <20211202123106.44245-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added documentation of trace file version 7.

This patch-set depends on
 "[PATCH v5 00/10] trace-cmd dump - v7 update" patch set.
  https://lore.kernel.org/linux-trace-devel/20211202122907.44008-1-tz.stoyanov@gmail.com/
 

v5 changes:
 - Rebased on top of the latest master. 
v4 changes:
 - Rebased on top of the latest master.  
v3 changes:
 - Rebased on top of the latest master.
v2 changes:
 - fixed issues of split and convert commands with some corner cases

Tzvetomir Stoyanov (VMware) (4):
  trace-cmd: Update bash completion
  tarce-cmd: Man page for "trace-cmd convert"
  tarce-cmd: Update record man page
  trace-cmd: Document trace file version 7

 .../trace-cmd/trace-cmd-convert.1.txt         |  65 +++
 .../trace-cmd/trace-cmd-record.1.txt          |  13 +
 Documentation/trace-cmd/trace-cmd.1.txt       |   4 +-
 ...e-cmd.dat.5.txt => trace-cmd.dat.v6.5.txt} |   9 +-
 .../trace-cmd/trace-cmd.dat.v7.5.txt          | 442 ++++++++++++++++++
 tracecmd/trace-cmd.bash                       |  37 ++
 6 files changed, 564 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/trace-cmd/trace-cmd-convert.1.txt
 rename Documentation/trace-cmd/{trace-cmd.dat.5.txt => trace-cmd.dat.v6.5.txt} (98%)
 create mode 100644 Documentation/trace-cmd/trace-cmd.dat.v7.5.txt

-- 
2.33.1

