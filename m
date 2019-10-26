Return-Path: <SRS0=Th4R=YT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D42CA9EB9
	for <linux-trace-devel@archiver.kernel.org>; Sat, 26 Oct 2019 15:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBF0320863
	for <linux-trace-devel@archiver.kernel.org>; Sat, 26 Oct 2019 15:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbfJZPqY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 26 Oct 2019 11:46:24 -0400
Received: from smtprelay0235.hostedemail.com ([216.40.44.235]:58661 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726162AbfJZPqY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 26 Oct 2019 11:46:24 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 5A300837F24A;
        Sat, 26 Oct 2019 15:46:23 +0000 (UTC)
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-HE-Tag: sea49_71eaa3ac02039
X-Filterd-Recvd-Size: 1177
Received: from grimm.local.home (unknown [12.156.218.74])
        (Authenticated sender: rostedt@goodmis.org)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Sat, 26 Oct 2019 15:46:22 +0000 (UTC)
Date:   Sat, 26 Oct 2019 11:46:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Greg Thelen <gthelen@google.com>
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] trace-cmd: refactor print_update
Message-ID: <20191026114620.2d63cea4@grimm.local.home>
In-Reply-To: <20191025063957.21558-1-gthelen@google.com>
References: <20191025063957.21558-1-gthelen@google.com>
X-Mailer: Claws Mail 3.17.4git49 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 24 Oct 2019 23:39:56 -0700
Greg Thelen <gthelen@google.com> wrote:

> Match utils.mk convention and use a conditional macro for printing
> 'UPDATE' messages.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  scripts/utils.mk | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>

Thanks Greg! I applied both patches.

-- Steve
