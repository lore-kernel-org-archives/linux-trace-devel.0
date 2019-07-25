Return-Path: <SRS0=vwbJ=VW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E23AAC76190
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 17:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C001A206DD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 17:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730032AbfGYRly (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 13:41:54 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:50574 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbfGYRly (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 13:41:54 -0400
Received: from chiana.gaikai.org (unknown [100.42.98.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chutzpah)
        by smtp.gentoo.org (Postfix) with ESMTPSA id C02FB348A57
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jul 2019 17:41:53 +0000 (UTC)
From:   Patrick McLean <chutzpah@gentoo.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/3] trace-cmd: More Python 3 cleanups
Date:   Thu, 25 Jul 2019 10:41:35 -0700
Message-Id: <20190725174138.3724131-1-chutzpah@gentoo.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some more cleanups for Python 3, these mostly fix warnings that are
generated when building the Python portions of the code for Python 3.

Patrick McLean (3):
      trace-cmd: in python plugin, use PyUnicode_FromString on Python 3
      trace-cmd: Add missing headers to Python template
      trace-cmd: In the ctracecmdgui use PyLong on Python 3


