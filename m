Return-Path: <SRS0=vdoy=BM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D7EFC433E0
	for <linux-trace-devel@archiver.kernel.org>; Sun,  2 Aug 2020 21:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E8462072A
	for <linux-trace-devel@archiver.kernel.org>; Sun,  2 Aug 2020 21:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgHBVJH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 2 Aug 2020 17:09:07 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:59350 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbgHBVJH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 2 Aug 2020 17:09:07 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id D249472CCE9;
        Mon,  3 Aug 2020 00:09:04 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 9C2814A4AE7;
        Mon,  3 Aug 2020 00:09:04 +0300 (MSK)
Date:   Mon, 3 Aug 2020 00:09:04 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Where is proper libtraceevent plugins tree?
Message-ID: <20200802210904.iotublzj5bmp32sl@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Steven,

I am trying to rework trace-cmd and perf packages for ALT Linux. But, I
found that trace-cmd 2.9 builds and installs /usr/lib64/traceevent/plugins
and perf builds and installs /usr/lib64/traceevent/plugins (some plugins
have same names, some different).

This would create bad files conflict in packaging system.

Both source trees seems to be recently updated:
  linux/tools/lib/traceevent/plugins/ and
  trace-cmd/lib/traceevent/plugins/

(trace-cmd 2.8 it installed these same plugins in /usr/lib64/trace-cmd/plugins).

How it's supposed to build and install (perf and trace-cmd) without conflicts?
Where is true (lib?)traceevent source tree?

Thanks,

