Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE8DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 21:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbiBVVHV convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 16:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbiBVVHT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 16:07:19 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B982512752
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 13:06:49 -0800 (PST)
Received: from bigeasy by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1nMcMw-0001vx-Af; Tue, 22 Feb 2022 22:06:46 +0100
Date:   Tue, 22 Feb 2022 22:06:46 +0100
From:   Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] trace-cmd library: Add ZSTD support.
Message-ID: <YhVQZm8sZNe6QEpq@breakpoint.cc>
References: <20220219230151.56282-1-sebastian@breakpoint.cc>
 <20220219230151.56282-2-sebastian@breakpoint.cc>
 <CAPpZLN7_xM7rp_C7KGjed-8W4nt+Yn0XiN8mpwVGLjgCboTmhQ@mail.gmail.com>
 <YhOZsr0TN+NkV3cU@breakpoint.cc>
 <CAPpZLN5pB-6fdF5Cw3x=N0GMLx0UL8kLB=ApoJa3iqBqJkSopQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAPpZLN5pB-6fdF5Cw3x=N0GMLx0UL8kLB=ApoJa3iqBqJkSopQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2022-02-22 05:42:56 [+0200], Tzvetomir Stoyanov wrote:
> We prefer to use explicit API arguments, to ensure that on API's
> change the old callers of the API will be updated. Using such
> structure is more flexible, but even though in most cases the change
> will be backward compatible - it could be hard to debug the legacy
> code in case the API's behaviour changes because of adding some new
> parameter in the structure.

It depends. xz, openssl, … have ABIs and structs which change. I assumed
that struct is internal to trace-cmd. But even if it isn't and it is
public then it is part of lib-trace-cmd's ABI. Once you change here
something you need to incremebt your so number and this requires to
recompile all downstream users aka a library transition.
By using C99 initializers you ensure that removed / replaced struct
members don't remain used.

> > As for func_t / calling convetion I would prefer something that is not
> > that close to zlib. Like
> >
> >         int comp(void *ctx, const void *src, signed int in_size,
> >                  void *dst, signed int out_size);
> >
> > This clearly limits the sizes to 31 bit (with the 40kiB probably okay)
> > and the return value can be either >= 0 returning the number of bytes
> > produced or negative for an error. And please no errno touching ;)
> >
> 
> I like the idea to make these hooks more generic, not so close to a
> specific library. 

You reassmeble the zlib thing. Here you have comp/decomp functions
with pointer and size. And instead updating dst' size you have a return
value defined as
 >= 0: decompressed / compressed to
  < 0: error number defined by trace-cmd

> But there should be some error reporting mechanism,
> why not to use errno ? In the best case, the library itself should set
> the errno. 

But why touching errno? errno is defined / used by the OS. Based on the
architecture the kernel returns two values. If sys_open succeeds then it
returns the file handle. On failure -1 and errno is set the actual
error. Some archiectures use two registers (one -1 and the other
positive errno) for that some use one (positive or negative errno). The
C-library then knows what the architecture does and ensures the API
stays the same.
A library like yours should not touch errno. If you encounter an error,
you should define your own error numbers and use those. So your
compression library detects a checksum error during decompression what
do you do? EINVAL because the input is invalid? EBADMSG because the
input is a bad message? But it is defined as "Not a data message" so
maybe not. Maybe EILSEQ becase the data sequence is invalid. So you
basically need to guess and pick something that close to what you have. 
While you could define your own codes and return those.

> But zlib has its own error codes, and according to its
> documentation not all of the APIs set errno in case of an error.
> That's why I added this explicit setting of errno in case of some
> Z_ERROR.

But I though you wanted to somethign generic and be close a specifc
library :)
zlib is not a good example in terms of an API. No matter if you look
zstd or xz _or_ something else recent (as in not from 80s). Both the
compression libs I mentioned perform explicit framing and you as the
user know when something ends. zlib is a little difficult sometimes. You
do have the luxury that you know your input. I remember rsync does some
things to be sure if there is an error or the input is actual over…

> Are you interested to submit a patch with these suggestions ? I also
> can do it, when Steven merges zstd support and before the next
> trace-cmd release.

Well if nobody objects, nobody does it first then maybe as I can't
promise that I can make time before the weekend (and the weekend is
currently full).

Sebastian
