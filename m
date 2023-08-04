Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6811C001DF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Aug 2023 12:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjHDMho convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 08:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjHDMhn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 08:37:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BA546A8
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Aug 2023 05:37:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87F1C61F5C
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Aug 2023 12:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDACC433C8;
        Fri,  4 Aug 2023 12:37:40 +0000 (UTC)
Date:   Fri, 4 Aug 2023 08:37:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v2 0/5] histograms: bug fixes and convention compliance
Message-ID: <20230804083737.0d8f1d95@gandalf.local.home>
In-Reply-To: <20230803225413.40697-1-stevie.6strings@gmail.com>
References: <20230803225413.40697-1-stevie.6strings@gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  3 Aug 2023 18:53:58 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> From: "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>
> 
> Changes in v2:
>  * Renamed interface from histograms.h to traceeval-hist.h.
>  * Internal traceeval_type arrays terminated by size rather than type.
>  * type_alloc() guarantees traceeval_type name field is a valid pointer.
>  * traceeval_release() sets released pointers to NULL.
>  * Conditional simplifications and fixes across the board. 
>  * Removed function stubs and their interface definitions.
>  * Added a timestamp flag.
>  * Added typedefs for traceeval_dynamic helper function signatures. 
>  * Documentation follows established conventions (kernel docs, line comments).
>  * Documentation moved from interface to source code.
>  * Internal testing interface.
>  * General documentation spell checking.
> 
> Since the addition of the traceeval_dynamic function signature typedefs,
> warnings pertaining to these function signatures and traceeval_type have
> popped up. Steven, Ross, and anyone else, any ideas on why these
> warnings are showing up?
> 
> Warning from function signatures in include/traceeval-hist.h, line 65 and 69:
> 	warning: ‘struct traceeval_type’ declared inside parameter list will
> 	not be visible outside of this definition or declaration
> 
> 		struct traceeval_type *);

This is because the typedef is before the declaration. Just add:

struct traceeval_type;

above it.

> 
> Warning from dyn_release call in src/histograms.c line 258:
> 	warning: passing argument 2 of
> 	‘(defs + (sizetype)(i * 48))->dyn_release’ from incompatible
> 	pointer type
> 
> 		defs[i].dyn_release(data[i].dyn_data, &defs[i]);

Try passing in: defs + i

I'll review these later today.

-- Steve

> 
> 	note: expected ‘struct traceeval_type *’ but argument is of type
> 	‘struct traceeval_type *’
> 
> Warning from dyn_cmp call in src/histograms.c line 409:
> 	warning: passing argument 3 of ‘type->dyn_cmp’ from incompatible
> 	pointer type
> 
> 		return type->dyn_cmp(orig->dyn_data, copy->dyn_data, type);
> 
> 	note: expected ‘struct traceeval_type *’ but argument is of type
> 	‘struct traceeval_type *’
> 
> ---
> v1 discussion: https://lore.kernel.org/linux-trace-devel/20230731212542.3fb668b1@gandalf.local.home/T/
> 
> Stevie Alvarez (Google) (5):
>   histograms: Initial histograms interface
>   histograms: Add traceeval initialize
>   histograms: Add traceeval release
>   histograms: Add traceeval compare
>   histograms: Initial unit tests
> 
>  Makefile                 |   2 +-
>  include/traceeval-hist.h | 135 ++++++++++
>  include/traceeval-test.h |  15 ++
>  src/Makefile             |   1 +
>  src/histograms.c         | 522 +++++++++++++++++++++++++++++++++++++++
>  utest/.gitignore         |   1 +
>  utest/Makefile           |  35 +++
>  utest/eval-test.h        |  13 +
>  utest/eval-utest.c       |  28 +++
>  utest/traceeval-utest.c  | 217 ++++++++++++++++
>  10 files changed, 968 insertions(+), 1 deletion(-)
>  create mode 100644 include/traceeval-hist.h
>  create mode 100644 include/traceeval-test.h
>  create mode 100644 src/histograms.c
>  create mode 100644 utest/.gitignore
>  create mode 100644 utest/Makefile
>  create mode 100644 utest/eval-test.h
>  create mode 100644 utest/eval-utest.c
>  create mode 100644 utest/traceeval-utest.c
> 

