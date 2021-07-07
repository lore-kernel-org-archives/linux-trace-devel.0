Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F3F9C07E95
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20D1D61CA8
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhGGNvk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jul 2021 09:51:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230509AbhGGNvk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 09:51:40 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56B0861C89;
        Wed,  7 Jul 2021 13:48:59 +0000 (UTC)
Date:   Wed, 7 Jul 2021 09:48:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: Re: [PATCH 4/4] libtracefs: Implement API to create / modify and
 display histograms
Message-ID: <20210707094852.2d5cd492@oasis.local.home>
In-Reply-To: <e766549f-daae-af99-8933-33eec53b97e9@gmail.com>
References: <20210707031110.249759-1-rostedt@goodmis.org>
        <20210707031110.249759-5-rostedt@goodmis.org>
        <0707117e-119a-c7b6-ee1e-ef57e49917ad@gmail.com>
        <20210707091327.138fe95f@oasis.local.home>
        <e766549f-daae-af99-8933-33eec53b97e9@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 7 Jul 2021 16:21:30 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Yes, sure.
> 
> But maybe in this case you can postpone the addition of the examples for 
> another patch that is after having those enhancements.

Well, the examples show how to use what is being described.

The new API patch could (and should) update the samples.

-- Steve
