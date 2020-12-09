Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C769C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:46:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FE8E23AC4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732403AbgLINqr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732187AbgLINqq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:46:46 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B13DC0613D6
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:46:06 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id m5so1802094wrx.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gxgmm/ZRoPaP64CbrtS0MaxdDUPCUYxGva0PyeKwwww=;
        b=i4xlvNMseMNk9eDNfEN5I4YTXsqoicl2wfF4+IRuq4K54ZDWnVYkkG11ueVmzfuF9k
         tzPY7en7KXwmxcHhwQtAWqPvy+yum4XXHv/ukkWCAwUOy7oiKJOxIQ+aBXHCwgquYftA
         J5BR/zwrf05b4KAF7anJaIxKwz6wz07vd5SaJjWCL12tm76q2c+E64uWYcJR8PSL7yHL
         7bF4tOsegJJVWA7tKpXkGiIN+qbTHzE5beuwDtTyqJTjO/DDuJdVmp8fup/P1BH0y9Ky
         l2DnNACs+x3Z/kRQBCRDnJY2blcpuzNMQEajzRv/BEga300r308V28CppnVAsw5nhp9m
         InIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gxgmm/ZRoPaP64CbrtS0MaxdDUPCUYxGva0PyeKwwww=;
        b=bNAyjLBPGBocVGD3I36Yq4cYTYaYo4rPdq2AePhezhojzJSMSpxLyEb115aW8Pzo4+
         t3Vj1EdpzTL/+yR7Pcb/U/tgQCcssOOVGi1j4kywkripWE2xLU8s3cjvSpVj3u71T2QH
         3AdiA4gcVEEesrCFK6445ODSvOSzn7BdW3yruc4uZTmwbbz4lAQ/7Z86DwcR6/fMtR4V
         RbNKGd5okUCfHogjdhln/HKHozHhh+XHNbK6qVr+KIKRXHK3HjEy6UBCX/UG8+XNrYgj
         bM1wPeR7OpZF0rnmzJQhv4i3q0j5PiZb0ZdSvcR8/TufnqmFb1EIGjQE7XmIR3eybpr9
         ySGA==
X-Gm-Message-State: AOAM533dW4eEBuz0OqJB1LiUAyQCoL4iMAUdNV7K7NHd9kV8nGmbSh29
        J2YeH9ySnZPDXBhGGEfEkOw=
X-Google-Smtp-Source: ABdhPJzhpm/VlJ9la7SdzPOyGEku+Chm7hJ1nlDXjxtJLHAt0qTbjTCTy/tkmtU7S7GDSKCen/64sQ==
X-Received: by 2002:a5d:6749:: with SMTP id l9mr2837953wrw.395.1607521565156;
        Wed, 09 Dec 2020 05:46:05 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id s1sm4029431wrv.97.2020.12.09.05.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:46:04 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 00/10] kernel-shark: Update the C++ tools for plotting
Date:   Wed,  9 Dec 2020 15:45:20 +0200
Message-Id: <20201209134530.428368-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Yordan Karadzhov (VMware) (10):
  kernel-shark: Integrate streams with KsPlotTools
  kernel-shark: Add getStreamColorTable()
  kernel-shark: Redefine the args of KsPlot::getColor()
  kernel-shark: Add TextBox class to KsPlot namespace
  kernel-shark: Consistent method naming in KsPlotTools
  kernel-shark: Make the label part of the graph
  kernel-shark: Remove the hard-coded Idle PID
  kernel-shark: Add class Polyline to KsPlot namespace
  kernel-shark: Add VirtBridge and VirtGap classes
  kernel-shark: Add double click interface to PlotObject

 src/CMakeLists.txt  |   4 +-
 src/KsPlotTools.cpp | 412 +++++++++++++++++++++++++++++++++++++-------
 src/KsPlotTools.hpp | 199 +++++++++++++++++----
 3 files changed, 519 insertions(+), 96 deletions(-)

-- 
2.25.1

