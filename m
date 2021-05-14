Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34604C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 18:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17BC26140E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 18:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235297AbhENSCY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 14:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235312AbhENSCW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 14:02:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B350261444;
        Fri, 14 May 2021 18:01:10 +0000 (UTC)
Date:   Fri, 14 May 2021 14:01:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 0/7] Final fixes before KS 2.0
Message-ID: <20210514140109.5615e1a2@gandalf.local.home>
In-Reply-To: <20210514121826.161749-1-y.karadz@gmail.com>
References: <20210514121826.161749-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 14 May 2021 15:18:19 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Yordan Karadzhov (VMware) (7):
>   kernel-shark: Preserve markers when appending data
>   kernel-shark: Preserve open graphs when appending data
>   kernel-shark: Clear before loading new session
>   kernel-shark: Better handling of plugins when appending data file
>   kernel-shark: Do draw the combo point of the mark
>   kernel-shark: Check if "trace_seq" was destroyed before using it
>   kernel-shark: Quiet the warning printing from libtraceevent
> 
>  

After applying and testing out this patch set, I realized that the appended
file does not have any of its CPUs plotted after it is loaded.

-- Steve
