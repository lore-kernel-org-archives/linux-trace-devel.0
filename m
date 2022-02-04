Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B4F4C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Feb 2022 13:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244318AbiBDNVg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Feb 2022 08:21:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52614 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233423AbiBDNVg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Feb 2022 08:21:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E25261BFE
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Feb 2022 13:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5262C340E9;
        Fri,  4 Feb 2022 13:21:34 +0000 (UTC)
Date:   Fri, 4 Feb 2022 08:21:32 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] libtracefs: clean also docs by default
Message-ID: <20220204082132.57be9bab@rorschach.local.home>
In-Reply-To: <652ddddb-6770-ca49-d00e-3b24ebc602a4@canonical.com>
References: <20220124105252.64897-1-krzysztof.kozlowski@canonical.com>
        <20220203214106.458cb2c4@gandalf.local.home>
        <652ddddb-6770-ca49-d00e-3b24ebc602a4@canonical.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 4 Feb 2022 09:59:06 +0100
Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com> wrote:


> I don't know actually, but I find natural that clean removes all
> objects, even ones not created by "make all".

The main reason I like to keep documentation clean and code clean
separate, is because when I develop between different branches,
checking out an older one then a newer one, the make dependencies can
get screwed up. A make clean usually solves the issue when that
happens. But I don't want to rebuild the documentation every time I do
a make clean.

> 
> I see your point, so I do not insist on this solution. I can fix the
> incomplete cleaning on Debian package side.
> 

Great. I'll take the second patch and drop this one then.

Thanks for your contributions!

-- Steve
