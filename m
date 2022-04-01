Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A9A6C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Apr 2022 23:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbiDAXIY convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Apr 2022 19:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbiDAXIX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Apr 2022 19:08:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D177B1A7748
        for <linux-trace-devel@vger.kernel.org>; Fri,  1 Apr 2022 16:06:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4830C61B75
        for <linux-trace-devel@vger.kernel.org>; Fri,  1 Apr 2022 23:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB13C2BBE4;
        Fri,  1 Apr 2022 23:06:30 +0000 (UTC)
Date:   Fri, 1 Apr 2022 19:06:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     linux-trace-devel@vger.kernel.org, rostedt@google.com,
        vineethrp@google.com, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH] trace-cmd: Try alternate path for message cache
Message-ID: <20220401190629.32564bd2@gandalf.local.home>
In-Reply-To: <CAEXW_YQxPgaKOMhDy8kVdaT9esvY8ctP1Mfw3RZXwkJkTYhh0w@mail.gmail.com>
References: <20220329191801.429691-1-joel@joelfernandes.org>
        <20220401153737.7c444426@gandalf.local.home>
        <CAEXW_YQxPgaKOMhDy8kVdaT9esvY8ctP1Mfw3RZXwkJkTYhh0w@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 1 Apr 2022 15:50:10 -0400
Joel Fernandes <joel@joelfernandes.org> wrote:

> export TRACECMD_TEMPDIR="/data"
> 
> That’s fair. What about using memfd for this, do you feel that’s
> reasonable? I have not yet measured how big this file gets but if it’s
> small enough that might work too.

Is this a separate question? That is, do you mean using the above
environment variable *and* then use memfd?

I believe that the cache is used for passing the compressed data from the
guest to the host. I don't think it will be more than one compressed chunk.

But Tzvetomir would know better.

-- Steve
