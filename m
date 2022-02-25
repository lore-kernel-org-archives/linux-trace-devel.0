Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308D1C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Feb 2022 00:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiBYAUk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 19:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235499AbiBYAUk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 19:20:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38DE270248
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 16:20:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63C4A61CDD
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Feb 2022 00:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEC5C340E9;
        Fri, 25 Feb 2022 00:20:08 +0000 (UTC)
Date:   Thu, 24 Feb 2022 19:20:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ian Rogers <irogers@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH 3/3] libtracefs: Move initialization below a null test.
Message-ID: <20220224192006.1d6a09f9@gandalf.local.home>
In-Reply-To: <CAP-5=fUmB4QgHTBBsnKkuhh7KHF2us-ZGkn_UB4ymxUkmO3ebA@mail.gmail.com>
References: <20220224234823.1190425-1-irogers@google.com>
        <20220224234823.1190425-3-irogers@google.com>
        <20220224185556.2771ad18@gandalf.local.home>
        <CAP-5=fUmB4QgHTBBsnKkuhh7KHF2us-ZGkn_UB4ymxUkmO3ebA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 24 Feb 2022 16:09:29 -0800
Ian Rogers <irogers@google.com> wrote:

> >  /**
> >   * tracefs_dynevent_get_event - return tep event representing the given dynamic event
> >   * @tep: a handle to the trace event parser context that holds the events
> >  
> 
> LGTM. Thanks,

Did you want to resend, or do you want me to just do this myself? I'm good
either way.

-- Steve
