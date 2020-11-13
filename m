Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D761C4742C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Nov 2020 14:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 232682222F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Nov 2020 14:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgKMOmg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Nov 2020 09:42:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:37720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgKMOmg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Nov 2020 09:42:36 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D351E21D1A;
        Fri, 13 Nov 2020 14:42:35 +0000 (UTC)
Date:   Fri, 13 Nov 2020 09:42:34 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 04/20] kernel-shark: Introduce Data streams
Message-ID: <20201113094234.03b5405b@gandalf.local.home>
In-Reply-To: <164442c9-0732-2fda-d6d2-96077d6f170e@gmail.com>
References: <20201112142358.36821-1-y.karadz@gmail.com>
        <20201112142358.36821-5-y.karadz@gmail.com>
        <20201112155051.18e226e9@gandalf.local.home>
        <164442c9-0732-2fda-d6d2-96077d6f170e@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 13 Nov 2020 15:47:04 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> >> +typedef enum kshark_event_field_format {
> >> +	/** A field of unknown type. */
> >> +	KS_INVALIDE_FIELD,  
> > 
> > 	KS_INVALID_FIELD ?
> >   
> 
> My idea is this identifier to be used for event fields having type that 
> is not supported by the interface. For example strings or arrays.

I was pointing out the spelling not the existence of it ;-)

Unless that 'E' at the end has some special meaning.

-- Steve
