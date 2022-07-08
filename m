Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 527FFC43334
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Jul 2022 18:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239518AbiGHSag (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Jul 2022 14:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238757AbiGHSaf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Jul 2022 14:30:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5987522F
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Jul 2022 11:30:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1FF862587
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Jul 2022 18:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EA7C341C0;
        Fri,  8 Jul 2022 18:30:32 +0000 (UTC)
Date:   Fri, 8 Jul 2022 14:30:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     linux-trace-devel@vger.kernel.org, cluster-devel@redhat.com
Subject: Re: [PATCH/RFC] java: add initial bindings
Message-ID: <20220708143031.29a271d7@gandalf.local.home>
In-Reply-To: <20220620204539.926948-1-aahringo@redhat.com>
References: <20220620204539.926948-1-aahringo@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 20 Jun 2022 16:45:39 -0400
Alexander Aring <aahringo@redhat.com> wrote:

Hi Alexander!


> This patch adds basic java bindings for libtracecmd. It currently
> supports very basic handling of parsing trace-cmd recorded trace files.
> There might of course additional improvements regarding swig bindings and
> the memory handling. E.g. in javas builtin iterator for-each handling
> everything will keep in memory. The license for the high-level java
> bindings jar file is LGPL-2.1 and is the same as libtracecmd.
> 
> The author of this patch created a java application that uses those java
> bindings to trace locks and represent them in graphical GANTT diagram,
> see [0].
> 
> You need to set the JAVA_HOME environment variable to let the Makefile know
> that it builds the java bindings. This is somehow standard in the java world
> as replacement for pkg-config or similar. There should no trace-cmd java
> dependency, the recommended way should be to provide a kind of trace-cmd-java
> package from your distribution containing the tracecmd.jar and
> libctracecmdjava.so. This package would have then a java dependency to
> e.g. OpenJDK, that I was using to test those bindings for.
> 
> The author is not a swig expert but it works as it currently is. Also
> the author did not hit issues because memory _yet_. Those are beginning
> experimental bindings and can be changed/improved in future.


Are you "the author"?

Could you rephrase this better? 

Like:

"There may be better ways to do this with swig, but this appears to work as
is, as there were no issues because of memory _yet_."

That is, please try to rewrite the change log without referring to yourself.

> 
> [0] https://gitlab.com/netcoder/dlm2slog2
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> ---
>  .gitignore                        |   4 +
>  Makefile                          |  60 ++++++-
>  java/Makefile                     |  39 +++++
>  java/TraceCmd.java                | 236 +++++++++++++++++++++++++
>  java/TraceCmdEvent.java           | 277 ++++++++++++++++++++++++++++++
>  java/TraceCmdException.java       |  16 ++
>  java/TraceCmdField.java           | 104 +++++++++++
>  java/ctracecmdjava.i              | 180 +++++++++++++++++++
>  java/example/Makefile             |   7 +
>  java/example/TraceCmdExample.java |  33 ++++
>  10 files changed, 953 insertions(+), 3 deletions(-)
>  create mode 100644 java/Makefile
>  create mode 100644 java/TraceCmd.java
>  create mode 100644 java/TraceCmdEvent.java
>  create mode 100644 java/TraceCmdException.java
>  create mode 100644 java/TraceCmdField.java
>  create mode 100644 java/ctracecmdjava.i
>  create mode 100644 java/example/Makefile
>  create mode 100644 java/example/TraceCmdExample.java
> 

I'm not a swig nor Java expert, and will likely not even test this code.
But I'm happy to include it if it doesn't break anything that I do test.
But if anyone complains of breakage, I'll simply point them to you ;-)

Are you OK with that?

Hmm, I should add a MAINTAINERS file to add people that support different
portions of trace-cmd.

-- Steve
