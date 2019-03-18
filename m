Return-Path: <SRS0=Onan=RV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8547EC4360F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Mar 2019 17:44:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 610BD2133F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Mar 2019 17:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbfCRRob (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Mar 2019 13:44:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727969AbfCRRoa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Mar 2019 13:44:30 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B2D52070D;
        Mon, 18 Mar 2019 17:44:29 +0000 (UTC)
Date:   Mon, 18 Mar 2019 13:44:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 06/12] kernel-shark: Load Last Session from command line
Message-ID: <20190318134428.30edd6d7@gandalf.local.home>
In-Reply-To: <094b949a-f2ba-95ea-7e76-1612e286a9a3@gmail.com>
References: <20190314151012.905-1-ykaradzhov@vmware.com>
        <20190314151012.905-7-ykaradzhov@vmware.com>
        <20190314194711.62436074@gandalf.local.home>
        <094b949a-f2ba-95ea-7e76-1612e286a9a3@gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 15 Mar 2019 08:13:10 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> > Am I missing something?
> >   
> 
> Looks like you are missing the two previous patch sets:
> 
> [PATCH v2 0/3]  Tuning the KernelShark build system
> and
> [PATCH v2 0/4] Add dialog for loading user-defined plugins

Please make sure to mention dependencies in the 0/X patch change log.
Each patch set should be stand alone unless explicitly stated otherwise.

As when you get a lot of change series, you may go backwards in
accepting them (which is what I do).

-- Steve
