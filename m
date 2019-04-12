Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0F9C10F14
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 17:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D12BC2077C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 17:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbfDLRZm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 13:25:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726711AbfDLRZl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 13:25:41 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA1DE2077C;
        Fri, 12 Apr 2019 17:25:38 +0000 (UTC)
Date:   Fri, 12 Apr 2019 13:25:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
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
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v5 1/3] Provide in-kernel headers to make extending
 kernel easier
Message-ID: <20190412132536.1211a66c@gandalf.local.home>
In-Reply-To: <76db9a89-ae64-5c2b-6f56-3e2b860cbda2@metux.net>
References: <20190320163116.39275-1-joel@joelfernandes.org>
        <CAOesGMheoZda84OSz9spQ7p66wot5S_9aaqaKC=QYp+8utASXA@mail.gmail.com>
        <20190408203601.GF133872@google.com>
        <CAOesGMibHCuMPCYkc8V++Z2Kuf3YQf_OjYn18GvDgzTy6ubV=g@mail.gmail.com>
        <CAK8P3a30yY_1mPcUBxOYOkbFwoeCHbo5EHuWMN4fqKug9DiQDQ@mail.gmail.com>
        <76db9a89-ae64-5c2b-6f56-3e2b860cbda2@metux.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 18:16:19 +0200
"Enrico Weigelt, metux IT consult" <lkml@metux.net> wrote:

> So, rpm doesn't count as "sane" ? :o
> 

As a Debian user... No ;-)

/me runs

-- Steve
