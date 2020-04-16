Return-Path: <SRS0=rfvd=6A=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3AB2C352BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Apr 2020 16:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1A7C221EB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Apr 2020 16:00:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TylPcK9a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636451AbgDPQAw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Apr 2020 12:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2636447AbgDPQAv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Apr 2020 12:00:51 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40646C061A0C
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Apr 2020 09:00:51 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id m2so5972149lfo.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Apr 2020 09:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jURn1ztmx6zW8MYVgNZCIF22y7gUILXIbHYibSsAS1I=;
        b=TylPcK9anegIePkYEWsY8JMjwLZf/iigFAoXbGS/eSjOjXtulLzECrlCh9l8FzRQD/
         SqFOlb4IOmxdeC2j6JwDiuT/cIuL4TA+YYRpCWFRb506VmuuZMO8Ghnwv5o9D+Dh62Wp
         Zx4heKKwbmu/NHs0E6arLeofdW+NXCSvmvjXTtn9SU/kkmsRe2siq5kHG/hWzhjrxqip
         8I2JElDLYU2Js3IrgjhTWK7qfo/6V20o6hBQRVKvfjzznXaaAqSNM1IBNkzXTnWB8WyC
         JzkcDJEDBRkW5fUQ1/hi0/otDg4dmFwobN3gcGZiuCikrTKjRghYf8GkSfK+yhXN0h1P
         rFRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jURn1ztmx6zW8MYVgNZCIF22y7gUILXIbHYibSsAS1I=;
        b=Tk68M3NC6goWx81rBHtx5twmkQTdTRJlHM0BGdWFszerjD0CuNs664bEWsCyxlxQiw
         1zmtHjZ3CKovnYChBdjHY3E90Iv4OW0IWhPn7EPpigeZ3NRF5yxmhb2PFDZY5Z/m6qo4
         Ze98p+N/7+7RX3A3I1cOv2zguawi4BRijCjRO887aN3PuG51dJTVDPzUJ2Beie15IRQ+
         sgRoWdRoRIm9IH2z0DNs8+w2jHyDq8M28/EZ1BMX43gwJLFnAjUQvO3SRCJN4KwIUYA1
         AhxnqF5Oq/fLwG5uW43ceT/AnyYyJwo3EET/iZ9aDY4Wodhr44FjWThECMIbfNCitx5g
         Vc4w==
X-Gm-Message-State: AGi0PubEeNwIXNMKFQ+Fpg8/ssCw0hEJOVa8HapMgzQQiQsG3c9NS+Iv
        z9xDbVayF21dTlcO7A58v8F9ZIWBC4E=
X-Google-Smtp-Source: APiQypJCv/U4e2pJbOxmUADtCsHet9/x5kWoQuM2VOE7BsZFevFoR1cpMlzX+end4ODzOgdrCow7lg==
X-Received: by 2002:a05:6512:406:: with SMTP id u6mr6555563lfk.150.1587052849572;
        Thu, 16 Apr 2020 09:00:49 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u2sm9030413lfk.67.2020.04.16.09.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 09:00:48 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/5] Various enhancements, related to reading trace.dat file
Date:   Thu, 16 Apr 2020 19:00:42 +0300
Message-Id: <20200416160047.77118-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir (VMware)  Stoyanov" <tz.stoyanov@gmail.com>

Few new tracemcd APIs were introduced recently, realted to opening
trace.dat file on stages, pairing files from the same tracing session,
getting extended guest VM information from the host trace file.
These patches allows KernelShark to leverage these tracecmd enhansments.

Tzvetomir (VMware)  Stoyanov (4):
  kernel-shark-2.alpha: Use new tracecmd APIs to open guest tracing file
  kernel-shark-2.alpha: Print the plugin's file name in case of loading
    error
  kernel-shark-2.alpha: Force trace-cmd.h to be used as plain C
  kernel-shark-2.alpha: Restructure KVMCombo plugin to use CPU mapping
    information from the trace files

Tzvetomir (VMware) Stoyanov (1):
  kernel-shark-2.alpha: Adjust the width of marker buttons

 src/KsDualMarker.cpp     |   4 +-
 src/libkshark-plugin.c   |   3 +-
 src/libkshark-tepdata.c  | 175 ++++++++++++++++++++++++++++++++++++++-
 src/libkshark-tepdata.h  |  10 +++
 src/plugins/KVMCombo.cpp | 160 +++++++++++++++--------------------
 src/plugins/KVMCombo.hpp |  16 ++--
 6 files changed, 260 insertions(+), 108 deletions(-)

-- 
2.25.1

