Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3085C636D7
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Feb 2023 05:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjBMFRf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Feb 2023 00:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjBMFRd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Feb 2023 00:17:33 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11DFEB6D
        for <linux-trace-devel@vger.kernel.org>; Sun, 12 Feb 2023 21:17:30 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id r8so12369926pls.2
        for <linux-trace-devel@vger.kernel.org>; Sun, 12 Feb 2023 21:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XLIWQ8RbOg6sIERcY+rOfB/UljKI6E/4LoKL2UnwekU=;
        b=VBICKi9KWjmiHWNiiw6cPbSN6c6W+2fPpdluRfuBSim10uqV6qdsk5AuHbZBcdkdV+
         xOdt7ch8KQKnVE1vx9e9e+9irUyh13lxxebRd0VQGZqJHxVF+jx4ZohFhx9D9mQWom3j
         TOJkg2ohEYHnCQtA3Dn9QC7dTmNQZOI32yecA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XLIWQ8RbOg6sIERcY+rOfB/UljKI6E/4LoKL2UnwekU=;
        b=7hZq0ugseWBQ6pFqk5bRbDpnMm5Dv07kzVlFsLFz4qtcDMnh/naBiBQL5sjz0AEXpP
         Ug2aUQ9SgrtJdGa/zbWBFaf1i8B15mrBZiBqNgoU98ybh/v54nn2MUrmwddGuxQQlhEX
         RddBoOBalHKUJy7wD1i3nUdXqNrHXxcqpa9NDETUGwg2IKbY18ZvL+ZG6udUwVuho0oI
         PLD2XNSmuKj5n2orwMtXST6+OZdoQ+PtjMCCLZUuRgN6rt+X7YqUYUdDe0ZCTsYD4Drm
         InZH6iVycvBe+H/GzJrNDAkfkWQP37rdtiOcmdT6/vK5b9OKoX7K0S1RGLouyy8msqcK
         S0kw==
X-Gm-Message-State: AO0yUKVCBMq82l3uWbf0l7+BZrwTznZzxBYAYkNj4sAyex2fLMPW+cNm
        TgrX4+4VAc0uL+hQL2zH3tHQfIGgCEFQQyDP
X-Google-Smtp-Source: AK7set95l72TNyTF65H1br/RJcjTdUUWsNrqjIfDxTR+w3m8zYylHzbjWTXXNthcheM3jXtDcUHqMA==
X-Received: by 2002:a17:902:c405:b0:19a:a9d8:e499 with SMTP id k5-20020a170902c40500b0019aa9d8e499mr169921plk.44.1676265450300;
        Sun, 12 Feb 2023 21:17:30 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:cfff:78bb:7eee:cacc])
        by smtp.gmail.com with ESMTPSA id n11-20020a170902968b00b00183c67844aesm7185753plp.22.2023.02.12.21.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 21:17:29 -0800 (PST)
Date:   Mon, 13 Feb 2023 14:17:27 +0900
From:   Hidenori Kobayashi <hidenorik@chromium.org>
To:     Douglas Raillard <douglas.raillard@arm.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        rostedt@goodmis.org, Nikita Baksalyar <nikita.baksalyar@gmail.com>
Subject: Re: libtraceevent + Rust
Message-ID: <20230213051727.hvkd5wgqhxi66gqh@google.com>
References: <96dc3f67-5405-c1a4-7c94-a98de3085cc5@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96dc3f67-5405-c1a4-7c94-a98de3085cc5@arm.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Douglas,

On Fri, Oct 14, 2022 at 04:16:33PM +0100, Douglas Raillard wrote:
> Hi everyone,
> 
> The idea of having some Rust interop for libtraceevent was floated during the
> Tracing Summit that took place this week.
> 
> The overall work has two scopes:
>     1. libtraceevent: low-level helpers to decode event formats and binary buffer pages.
>     2. high level API that e.g. can consume a trace.dat file and expose an iterator API etc.
> 
> The current discussion is only about #1. The 2nd part of the work has an
> entirely different set of constraints as it would aim at integrating in the
> Rust ecosystem as well as possible without trying to replace anything
> pre-existent.
 
Has anyone actually started working on these?

I have a Rust tool that parses the output from trace-cmd to infer the
internal states of a kernel module. While it serves our needs for now,
Steven kindly pointed me to this thread and suggested interacting
directly with the tracefs and using the tracefs libraries for parsing.

So I'd like to know:
- if this discussion reached a consensus
- if there is any publicly available work already

 
> * Rust bindings for C code:
>     Pros:
>         * Faster to implement
>         * By construction, any current covered use case stays covered.
> 
>     Cons:
>         * Less straightforward to build and distribute on crates.io. Current
>           best practice seems to simply expect the C lib to already be
>           compiled/installed on the host system and find it with pkg-config.
>           Otherwise, the lib sources can be bundled and a build recipe
>           included. At any rate, it will bring back the daemons of C package
>           management world where Rust typically only requires "cargo build" to
>           obtain a working binary.
> 
>         * More unsafe code overall when combined with higher level Rust code.
> 
> 
> * Rust implementation:
>     Pros:
>         * Occasion to fix unsatisfactory points in the current API:
>             * Some inefficiencies due to looking up fields by name mentioned
>               by Steven (correct that if I did not get it right).
> 
>             * Some unsatisfactory naming convention (Steven).
> 
>             * Event format is hard to parse as lots of event strongly
>               depends on the format string to specify the actual type. E.g. The
>               print event uses unsigned long for "ip" and then casts to (void*)
>               in the format string. sched_switch or mm_page_alloc require even
>               more advanced C parsing power to extract info necessary to
>               correctly/usefully represent the state type in most languages.
>               This might be fixable with more codified best practices and
>               fixing existing trace events, but we would still need to deal
>               with the existing situation for a few more years at best.  A new
>               API could merge the type info from the parsed print format with
>               the other "ABI info" to expose a richer representation to
>               consumers.
> 
>         * Can be used by higher level Rust code, preserving soundness
>           guarantees end to end.
> 
>         * Can open new use cases such as:
>             * Likely easier to maintain Python bindings using e.g. PyO3
>             * Good WASM support is something the Rust community cares about, so
>               that might open an avenue for new trace visualization tools.
> 
>     Cons:
>         * More work than just making bindings for existing C code.
>         * Portability: is there any architecture not currenlty supported by
>           Rust we care about ?
>         * New toolchain required to build the code. rustup solves that issue
>           very well though.
> 
>     Possible cons requiring a prototype to check:
>         * If we aim at 100% API/ABI compatibility with current libtraceevent,
>           this may force Rust code into very non-idiomatic code that may affect
>           the benefits of the language.
> 
>         * While it can still be exposed to C code, some soundness
>           guarantees will likely be lost in passing: Rust ref to C pointer
>           conversion is statically lossy. Having a func implemented in Rust
>           does not magically make consuming C compilers smarter and able to
>           check for memory safety. The improvement would only be inside the
>           implementation itself, but if we expose relatively simple low level
>           helpers the advantage is decreased.
> 
> 
> I'm sure I missed some things, so let's use this thread to get a better view of
> where to head next.
> 
> Steven also made a twitter poll on the matter:
> https://twitter.com/srostedt/status/1580589911706521600
> 
> 
> Thanks,
> 
> Douglas
> 
> IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
> 

Thanks,
Hidenori
