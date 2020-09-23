Return-Path: <SRS0=5IH7=DA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A55C4363D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Sep 2020 15:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3A3223119
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Sep 2020 15:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgIWPYy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Sep 2020 11:24:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbgIWPYy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Sep 2020 11:24:54 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A95B92220D;
        Wed, 23 Sep 2020 15:24:53 +0000 (UTC)
Date:   Wed, 23 Sep 2020 11:24:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: libtraceevent internal functions
Message-ID: <20200923112452.07d59fa0@oasis.local.home>
In-Reply-To: <CAPpZLN67R8C_bjxVp+x2kOJ4EpT3_TyTx=ZVz-WgWXFGhH2r+Q@mail.gmail.com>
References: <CAPpZLN5k-SRynd=q-dD4swu2qkqx3FE1_MLkB0x9bN=77hmsdA@mail.gmail.com>
        <CAPpZLN67R8C_bjxVp+x2kOJ4EpT3_TyTx=ZVz-WgWXFGhH2r+Q@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 23 Sep 2020 10:47:43 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> Hi Steven, I did a quick research of these functions. Some of them
> should be library APIs and some should be internal only
> That is what I found:
> 
> These are used only in the library, going to hide them:
>    tep_peek_char
>    tep_buffer_init
>    tep_get_input_buf_ptr
>    tep_get_input_buf
>    tep_read_token
>    tep_free_token
> 
> These are used by perf and trace-cmd, going to add a man page for them:
>    tep_print_printk
>    tep_add_plugin_path
>    tep_print_funcs
> 
> These are not used anywhere yet, but look like APIs, going to add a
> man page for them:
>   tep_set_test_filters
>   tep_plugin_print_options
> 
> This one is already an API with man page, it is in the list by mistake
>   tep_load_plugins_hook
> 

Hi Ceco,

Looks good. Thanks for the update.

-- Steve
