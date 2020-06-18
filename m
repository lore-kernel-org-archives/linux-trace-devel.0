Return-Path: <SRS0=0fRq=77=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C92AC433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 19:27:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19AC0207E8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 19:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgFRT1c (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Jun 2020 15:27:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726993AbgFRT1c (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Jun 2020 15:27:32 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26CB22070A;
        Thu, 18 Jun 2020 19:27:32 +0000 (UTC)
Date:   Thu, 18 Jun 2020 15:27:30 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: libtraceevent sync
Message-ID: <20200618152730.2790ba80@oasis.local.home>
In-Reply-To: <CAPpZLN6CKjMD4norOmvQ9PP0KXKrAGXr4PQxYhEqfvWUcFUiuQ@mail.gmail.com>
References: <CAPpZLN4RkWjAFBw=wShOMhQ0ECWJnDiOyQQPP6os68pSM9VeBQ@mail.gmail.com>
        <20200618095831.45958f30@oasis.local.home>
        <CAPpZLN6CKjMD4norOmvQ9PP0KXKrAGXr4PQxYhEqfvWUcFUiuQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 18 Jun 2020 19:03:41 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > This hasn't already been updated (haven't gone and looked)?  
> Most of the files in "tools/lib/traceevent/plugins/" have no "SPDX
> License" header, should we update them ?

Yes, and they should all be LGPL.

Thanks!

-- Steve
