Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F20C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jan 2022 14:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237151AbiAQOks (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 09:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234620AbiAQOkr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 09:40:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE66C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 06:40:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56FF360439
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 14:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3DDC36AE3;
        Mon, 17 Jan 2022 14:40:46 +0000 (UTC)
Date:   Mon, 17 Jan 2022 09:40:44 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 04/25] trace-cmd library: Add strings section in
 trace file version 7
Message-ID: <20220117094044.0933764c@rorschach.local.home>
In-Reply-To: <CAPpZLN61aKN+TdgB6Ac9JhyoNujQu_P5X3VH1QzvhCkL+xJUkg@mail.gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
        <20211210105448.97850-5-tz.stoyanov@gmail.com>
        <20220115075347.66d46b7f@rorschach.local.home>
        <CAPpZLN61aKN+TdgB6Ac9JhyoNujQu_P5X3VH1QzvhCkL+xJUkg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 17 Jan 2022 11:32:10 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > Does it have to be at the end of the file?  
> 
> The v7 file can have multiple string sections. The last string section
> must be at the end of the file, as it contains meta-data strings from
> the other sections.

Right, but it's not a requirement. It's more of what just happens. My
concern is that it reads as a requirement not something that just
happens to be an implementation side effect.

-- Steve
