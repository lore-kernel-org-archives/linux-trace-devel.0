Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B01C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jan 2022 16:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237560AbiAQQRS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 11:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235158AbiAQQRR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 11:17:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F47C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 08:17:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBF45B80C85
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 16:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C00DC36AE3;
        Mon, 17 Jan 2022 16:17:14 +0000 (UTC)
Date:   Mon, 17 Jan 2022 11:17:12 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 16/25] trace-cmd library: Read headers from trace
 file version 7
Message-ID: <20220117111712.4e732bd2@rorschach.local.home>
In-Reply-To: <CAPpZLN7EFy=S9UaidojoCnfXPVgU-=SbXSGUjA88maT_wfWEUA@mail.gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
        <20211210105448.97850-17-tz.stoyanov@gmail.com>
        <20220115105959.591892e1@gandalf.local.home>
        <CAPpZLN7EFy=S9UaidojoCnfXPVgU-=SbXSGUjA88maT_wfWEUA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 17 Jan 2022 17:47:27 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> The read header logic is very different, we should name the old
> function somehow. Now we have
>            read_headers_v6() / read_headers_v7()
> I can rename them to
>            read_headers_old() / read_headers()
> or
>            read_headers_nosections() / read_headers_sections()

The _v6 names are fine. I'm only talking about the new _v7 ones (as
that's now the main ones, and v8 may use it too).

-- Steve
