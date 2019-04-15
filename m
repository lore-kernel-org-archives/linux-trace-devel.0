Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA59CC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 09:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 966902077C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 09:42:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfDOJmU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 05:42:20 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:48267 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfDOJmT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 05:42:19 -0400
Received: from [192.168.1.110] ([95.115.91.41]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1N0qmr-1gtCPH1NZ7-00wpnv; Mon, 15 Apr 2019 11:41:22 +0200
Subject: Re: [PATCH v5 1/3] Provide in-kernel headers to make extending kernel
 easier
To:     Olof Johansson <olof@lixom.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Joel Fernandes <joelaf@google.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Manoj Rao <linux@manojrajarao.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>,
        Android Kernel Team <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
References: <20190320163116.39275-1-joel@joelfernandes.org>
 <CAOesGMheoZda84OSz9spQ7p66wot5S_9aaqaKC=QYp+8utASXA@mail.gmail.com>
 <20190408203601.GF133872@google.com>
 <CAOesGMibHCuMPCYkc8V++Z2Kuf3YQf_OjYn18GvDgzTy6ubV=g@mail.gmail.com>
 <CAJWu+or0hWce9+7aEfTHoOR8cptRbzHYVL-bPdJWGZH20dbo7Q@mail.gmail.com>
 <CAOesGMiuGK-Sbqo2z=1ab070JONav1LF82MRRLCdX-4+14_XZA@mail.gmail.com>
 <20190411031540.ehezr6kq7ouobpzx@ast-mbp.dhcp.thefacebook.com>
 <CAOesGMgiPB=7FE7tXXHes7WSLfByyPxirOStoH21NZqMwaUihQ@mail.gmail.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Organization: metux IT consult
Message-ID: <463a08cb-d1ac-b750-c699-8242c2c20fd2@metux.net>
Date:   Mon, 15 Apr 2019 11:41:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAOesGMgiPB=7FE7tXXHes7WSLfByyPxirOStoH21NZqMwaUihQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:TBuzl5G5ovLUaY43Qv+hnIQusro/f1muW+TE0KRY5F/cVh+vcvu
 j4WZFMgyNqn4uUcLSz/RCQGVZh8C7dd9YeNBA4zeaMM5zeA3s/eXDphNdj5+3vchxduzTB0
 FUr7g2wGw29dZNdOoZCj+fVFHNSDvQwDwSh8gMpGu2Jp9wQuRKrqwZbZ+9TkLdyeMaPtcCY
 2WEPV9bf2zZUFuceQCBYw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:jLcjNOcMryQ=:LBRLfE5/eMs5y6nnNNDnlE
 DIohbMWLtKarFWrSf0oMDwLOg/17heS1XD9FpP+XB6dtJ3ytFqbcVlFA2ouS/s/10vfrJ7Jy4
 3I9AuclxJxIbJmx09wNzeeAydtAXaf9BpkFlGfMXkXgQHy9fcmG2487qd0LST4O93ln2pKzEr
 967OBdSAmqo61rHAm38v60asQuQF/m8YTlhHCD6ljQVpKtW8T3SXuPYewRR6aNNuDe9sPp8h6
 G5GOP9i5IEDSRWfTkN6G5USUYbod1XdyUdtR4k96c7kon7X20CB/2xx7bXdYRtbSWrGAB8fIl
 ebedUvz4oPhX6RROXCmJhaJaoOfO1ndNJ5gkFKoOSRPB2JFTWtnfFampGll235C40Ln54agI1
 u05E4xA6mi7wGyGjgSXcCk+fJ+H+lPxgh5JmeIwqo/q3wz8THG1xTvID92pp80RVLMIGHMOBh
 8OvtVJ5dvJAQkc6Ambx01m0pVfGBlCbk3TiX++4lZj6z2jazOKUpeWmR90OqZXpAdmg+Uwf/v
 1k53fhxTRAAet0VDz5CvsuQQQQQ0tPMMrgo6R4Dh4SZUB8QbWHjcRD+pjEUXo8hj8ayOTg0HN
 SeIZUfP97vESSQR+LOFi4lSCCCP002f66sB0lZhBSSkqKTKpSqi2rf+AIWX1OYYJsR23sxLMh
 pZk+k/K9bL59ghBwW3QC8mUYEoc12SlQQJ5ZqU5DM9CKjPBZa33YQeuQ26cxlyFl022p4dru5
 CxZ6urefnibXTtCYYpq+xJEurjUznWpHlY4To36yJFq2Yvo3NxDTqCZXXu8=
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 14.04.19 21:38, Olof Johansson wrote:

Hi folks,


I haven't followed these longs discussions completely, so forgive me if
I've missed something. But here're my comments on this ...

> In the grand scheme of things, open/mmap syscalls wouldn't necessarily> be slower.
ACK. In my own experience on dealing w/ lots of files, eg. headers, in
compilation processes, there indeed is a bottleneck, when thousands of
files have to be processed, but:

a) most the kernel-side delay's were coming from actual IO - w/ tmpfs,
   that easily goes away, and the syscall overhead isn't so much.
b) most of the total computation was preprocessor and parsing.

> This patch seems to have been met with a lot of responses in the tone> of "this is not an appealing solution".

Personally, having generic helpers for putting blobs into /proc files
(like config.gz) sound appealing. But I'm not sure whether doing that
w/ kernel headers this way is a good solution. Actually, I'm even not
sure whether raw kernel headers are at all are a good way. (can't we
use compiler-generated debug info ?)

> Usually what we do at times like this is that we say "Yeah, this is a> problem that should be solved, but this solution doesn't seem to be>
the right one and we would need to maintain it forever as part of the>
ABI. Let's wait until a better solution is found." With time,> sometimes
a better solution becomes obvious, or circumstances change> enough to
allow for some different approach, or someone has a new idea> from a
different perspective that solves the same problem.
ACK. For now, this is an Android-only debug tool, just needed there
because of it's unusual partitioning/deployment mechanisms - on usual
GNU/Linux distros, we just have the kheaders in the file system.
(and even on my small embedded devices, I either run the DUTs via NFS,
9P2k, initrd, etc or just deploy kernel and headers into the filesystem)

As Android already is in it's own universe, why can't that stuff remain
incubated there, until we have more field experience w/ it and more time
to rethink the whole idea very carefully ?

The patch is pretty small, so it's trivial cherry-pick, in case somebody
outside Android universe wants to use it.

I see two smaller sub-problems that IMHO deserve a more generic
solution:

#1: generic helpers for easily exposing in-kernel blobs as /proc files
    (potentially w/ transparent decompression)

#2: generic way for easily linking in files with very few LoC

    one scenario that I've got in mind is using dtb snippets for board
    drivers, that only need to initialize some generic drivers w/
    board specific configuration, so that doesn't have to be hand-
    written anymore.


> I'd be a *lot* less hesitant if this went into debugfs or another
> location than /proc, which is one of the most regression-sensitive
> interfaces we have in the kernel.

ACK. I don't think that /proc really is the right place for that.
Actually, I even doubt that for config.gz , it's just historically
there (many distros already disabled it for many years). IMHO, /proc
is for process information. (i guess that was also a reason for creating
debugfs instead of putting that stuff into /proc).


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
