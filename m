Return-Path: <SRS0=TfJx=VR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4693DC7618F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 20 Jul 2019 03:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 255772082F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 20 Jul 2019 03:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390432AbfGTDD4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Jul 2019 23:03:56 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39658 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728058AbfGTDD4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 23:03:56 -0400
Received: from chiana.gaikai.org (unknown [100.42.98.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chutzpah)
        by smtp.gentoo.org (Postfix) with ESMTPSA id C5569348118
        for <linux-trace-devel@vger.kernel.org>; Sat, 20 Jul 2019 03:03:55 +0000 (UTC)
From:   Patrick McLean <chutzpah@gentoo.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/4] trace-cmd: Fixes for packaging
Date:   Fri, 19 Jul 2019 20:03:40 -0700
Message-Id: <20190720030344.1991393-1-chutzpah@gentoo.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

These are various patches to trace-cmd I needed to use to package both
it and kernelshark on Gentoo. Some of these may not be needed by other
distros, as these are at least partially to help with building them
as completely separate packages.


