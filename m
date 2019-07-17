Return-Path: <SRS0=BCkm=VO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5627CC76186
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jul 2019 13:28:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36B1320659
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jul 2019 13:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbfGQN2V (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Jul 2019 09:28:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfGQN2U (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Jul 2019 09:28:20 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC34E20659;
        Wed, 17 Jul 2019 13:28:19 +0000 (UTC)
Date:   Wed, 17 Jul 2019 09:28:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] kernel-shark: Initialize the data-related fields of
 the model
Message-ID: <20190717092818.34329697@gandalf.local.home>
In-Reply-To: <3117115a-5468-1b26-9a89-d871f43a1289@gmail.com>
References: <20190717085306.12393-1-y.karadz@gmail.com>
        <20190717085306.12393-2-y.karadz@gmail.com>
        <20190717083709.4a56867c@gandalf.local.home>
        <3117115a-5468-1b26-9a89-d871f43a1289@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 17 Jul 2019 15:42:31 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> > Are we just trying to set all fields of histo to NULL or zero? If so,
> > why not just do:
> > 
> > 	memset(histo, 0, sizeof(*histo));
> > 
> > ?
> > 
> > This will make sure ksmodel_init() zeros all of histo when/if we add new
> > fields.
> >   
> 
> Yes, this will do a better job.

Care to send a v2 patch?

Thanks Yordan!

-- Steve
