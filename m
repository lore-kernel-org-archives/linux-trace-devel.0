Return-Path: <SRS0=SJyJ=7R=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87F62C433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Jun 2020 19:30:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EDDF2077D
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Jun 2020 19:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbgFDTaD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Jun 2020 15:30:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728809AbgFDTaD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Jun 2020 15:30:03 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30EEC2077D;
        Thu,  4 Jun 2020 19:30:02 +0000 (UTC)
Date:   Thu, 4 Jun 2020 15:30:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: [POC] Add APIs for extracting DWARF
 information from a file
Message-ID: <20200604153000.1dfecc2c@oasis.local.home>
In-Reply-To: <20200604152013.248629a5@oasis.local.home>
References: <20200521105519.31391-1-tz.stoyanov@gmail.com>
        <20200604152013.248629a5@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 4 Jun 2020 15:20:13 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 21 May 2020 13:55:19 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> 
> 
> Hi Tzvetomir,
> 
> Thanks for doing this.

I just realized there's no interface into this code. Do you have a
patch that executes it? Can you post that too, or have you already and
I'm just missing it?

Thanks!

-- Steve
