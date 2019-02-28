Return-Path: <SRS0=lLCO=RD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C479CC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 16:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B5A2218CD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 16:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfB1Qdg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 11:33:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:42638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbfB1Qdg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 11:33:36 -0500
Received: from vmware.local.home (unknown [38.88.19.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 644E2218AE;
        Thu, 28 Feb 2019 16:33:35 +0000 (UTC)
Date:   Thu, 28 Feb 2019 11:33:34 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: Re: Can't use kvm_exit for the host side time stamp
Message-ID: <20190228113334.59f1f785@vmware.local.home>
In-Reply-To: <CACqStocgP+F+Kvr4a3a28V1ACEM=kbKVVSJxGbb0CiN9WdNKaA@mail.gmail.com>
References: <20190226112406.7abab75a@vmware.local.home>
        <CACqStocgP+F+Kvr4a3a28V1ACEM=kbKVVSJxGbb0CiN9WdNKaA@mail.gmail.com>
X-Mailer: Claws Mail 3.15.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 28 Feb 2019 16:22:41 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> The problem is that
> vmx_read_l1_tsc_offset() is Intel specific, most probably it is not
> used on non-Intel CPUs.

Correct, but we should be able to easily determine that by checking
which module is loaded (kvm_intel or kvm_amd). I'm sure we can just use
the equivalent for amd.

But again, this needs to be able to work with non-x86 too, which means
at the end, we need to make this configurable. Either by having plugins
loaded by checking what system it is on, and seeing what options are
available.

-- Steve
