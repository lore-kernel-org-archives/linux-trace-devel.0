Return-Path: <SRS0=UiB3=23=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A03CC33C8C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 14:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9D2C2075A
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 14:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgAFOzm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 09:55:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgAFOzm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 09:55:42 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEED22075A;
        Mon,  6 Jan 2020 14:55:41 +0000 (UTC)
Date:   Mon, 6 Jan 2020 09:55:40 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v18 13/18] trace-cmd: Add guest information in host's
 trace.dat file
Message-ID: <20200106095540.4aa34c42@gandalf.local.home>
In-Reply-To: <CAPpZLN5HaooBR4i=gb874eyTVBjdtwT2e=3G7+1gBv1yqiBOPw@mail.gmail.com>
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
        <20191213153029.133570-14-tz.stoyanov@gmail.com>
        <20191220155221.6face370@gandalf.local.home>
        <CAPpZLN5HaooBR4i=gb874eyTVBjdtwT2e=3G7+1gBv1yqiBOPw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 6 Jan 2020 16:43:03 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> We could think of implementing some stand alone trace.dat file reader,
> to extract and display that meta data information.

This is the right thing to do. I've actually started doing this here
and there, but mostly via the trace-cmd report options.

But we should have a full parser of the trace.dat file. Could be an
option for trace-cmd. "trace-cmd dump"?

-- Steve
