Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52AD2C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Jul 2022 13:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiGMNkw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Jul 2022 09:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiGMNko (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Jul 2022 09:40:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 91FFABE36
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Jul 2022 06:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657719641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AKJFqVAEYMrSYdd5FQG6UXoFSGFARh5VVh8jAz8BGD4=;
        b=EQBFiQQ1QOYGs/2d+ubrPzFYZvf337ygG7DLGi6i1SU+8cdYEfwh25qJmKk9eHDL6Uxny3
        /G+flZjUXn9o9dxlUyp1YBCzZVFs1UzWt+GALXeLA3PA5jWsbdNYj7L0iLk1I4w7jPy4FM
        5NzqVe8CTr+YeRGE3ZkVd4bZHxcMj0k=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-uqsgnbypPneereonQSth-Q-1; Wed, 13 Jul 2022 09:40:40 -0400
X-MC-Unique: uqsgnbypPneereonQSth-Q-1
Received: by mail-qk1-f199.google.com with SMTP id s9-20020a05620a254900b006b54dd4d6deso9880454qko.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Jul 2022 06:40:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AKJFqVAEYMrSYdd5FQG6UXoFSGFARh5VVh8jAz8BGD4=;
        b=3eCUQmQ86KEDWqaLT3OyZJiSWrXRfe1vVQlNYAKpaNmOJa50wKCKrVOyog842OpYcl
         6iyIi/uJO+SRbxecRSeZQ/Nrj51TGCwcri0p6Xogk54c7+eCQSShw68ELYTFjNDp0hEb
         t9Dsk3stEtllDLIbsuKvbS0CuooZl1XmF/AzY7nXV/dhG2hV4yTnfsfZZDbKCBsxSyIU
         zlnzPFv0nGjtfcr6/0UFgB6VgwhAHbtNcfKNxWjhvZn3lEsQcn28qUKFQ8sYOoS5LOU/
         yzcJK9Uz1Cukv14c9xMytW7O7DLrnZ2nE0deBSkxf5QBKU/qkqYBXraleZd1HKc3uJkO
         fdqQ==
X-Gm-Message-State: AJIora8CDYPr8UY8COLwXifvShBEXVcWR/MHUTNG7gT2x0tYj8X7wX28
        qQDCkzqbSuehvMOoO4zr/h+Tkgw3DU2fENgYzyDFnWpadNxwSsJemyKf2ONxCcQu6xfx2Yk8kw2
        +uL3yNr7nPww5I85p+mEd/R3Ma1GsZoAH+hDH0y8sOf0IQ7I=
X-Received: by 2002:a05:620a:468d:b0:6b5:9e91:4b40 with SMTP id bq13-20020a05620a468d00b006b59e914b40mr2331740qkb.80.1657719639451;
        Wed, 13 Jul 2022 06:40:39 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uCnsh2Bv7xdTn4Gno39lxl0GxulXCeCnYySAGcf7LLtM5dFyAScpi8FOd/bQHhcZpD/DDq0AfPHWXnNfxLrSU=
X-Received: by 2002:a05:620a:468d:b0:6b5:9e91:4b40 with SMTP id
 bq13-20020a05620a468d00b006b59e914b40mr2331717qkb.80.1657719639134; Wed, 13
 Jul 2022 06:40:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220620204539.926948-1-aahringo@redhat.com> <20220708143031.29a271d7@gandalf.local.home>
In-Reply-To: <20220708143031.29a271d7@gandalf.local.home>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 13 Jul 2022 09:40:28 -0400
Message-ID: <CAK-6q+guYP=X-QKayUeHc_a2r363K9=ES9sakKu9WYB908-0Bg@mail.gmail.com>
Subject: Re: [PATCH/RFC] java: add initial bindings
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        cluster-devel <cluster-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

On Fri, Jul 8, 2022 at 2:31 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 20 Jun 2022 16:45:39 -0400
> Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi Alexander!
>
>
> > This patch adds basic java bindings for libtracecmd. It currently
> > supports very basic handling of parsing trace-cmd recorded trace files.
> > There might of course additional improvements regarding swig bindings and
> > the memory handling. E.g. in javas builtin iterator for-each handling
> > everything will keep in memory. The license for the high-level java
> > bindings jar file is LGPL-2.1 and is the same as libtracecmd.
> >
> > The author of this patch created a java application that uses those java
> > bindings to trace locks and represent them in graphical GANTT diagram,
> > see [0].
> >
> > You need to set the JAVA_HOME environment variable to let the Makefile know
> > that it builds the java bindings. This is somehow standard in the java world
> > as replacement for pkg-config or similar. There should no trace-cmd java
> > dependency, the recommended way should be to provide a kind of trace-cmd-java
> > package from your distribution containing the tracecmd.jar and
> > libctracecmdjava.so. This package would have then a java dependency to
> > e.g. OpenJDK, that I was using to test those bindings for.
> >
> > The author is not a swig expert but it works as it currently is. Also
> > the author did not hit issues because memory _yet_. Those are beginning
> > experimental bindings and can be changed/improved in future.
>
>
> Are you "the author"?
>

yes.

> Could you rephrase this better?
>
> Like:
>
> "There may be better ways to do this with swig, but this appears to work as
> is, as there were no issues because of memory _yet_."
>
> That is, please try to rewrite the change log without referring to yourself.
>

okay.

> >
> > [0] https://gitlab.com/netcoder/dlm2slog2
> > Signed-off-by: Alexander Aring <aahringo@redhat.com>
> > ---
> >  .gitignore                        |   4 +
> >  Makefile                          |  60 ++++++-
> >  java/Makefile                     |  39 +++++
> >  java/TraceCmd.java                | 236 +++++++++++++++++++++++++
> >  java/TraceCmdEvent.java           | 277 ++++++++++++++++++++++++++++++
> >  java/TraceCmdException.java       |  16 ++
> >  java/TraceCmdField.java           | 104 +++++++++++
> >  java/ctracecmdjava.i              | 180 +++++++++++++++++++
> >  java/example/Makefile             |   7 +
> >  java/example/TraceCmdExample.java |  33 ++++
> >  10 files changed, 953 insertions(+), 3 deletions(-)
> >  create mode 100644 java/Makefile
> >  create mode 100644 java/TraceCmd.java
> >  create mode 100644 java/TraceCmdEvent.java
> >  create mode 100644 java/TraceCmdException.java
> >  create mode 100644 java/TraceCmdField.java
> >  create mode 100644 java/ctracecmdjava.i
> >  create mode 100644 java/example/Makefile
> >  create mode 100644 java/example/TraceCmdExample.java
> >
>
> I'm not a swig nor Java expert, and will likely not even test this code.
> But I'm happy to include it if it doesn't break anything that I do test.
> But if anyone complains of breakage, I'll simply point them to you ;-)
>
> Are you OK with that?
>
> Hmm, I should add a MAINTAINERS file to add people that support different
> portions of trace-cmd.
>

I already created a new project trace-cmd-java [0]. This will static
link against libtracecmd and their dependencies. At the end it
produces a binary blob for the java bindings. The advantage here is
that I have full control over the used version of libtracecmd and
their dependencies.

I would like to go this way and see how it goes. Meanwhile I can do
more testing and cleanups. I may come back again to bring it upstream.

- Alex

[0] https://gitlab.com/netcoder/trace-cmd-java

