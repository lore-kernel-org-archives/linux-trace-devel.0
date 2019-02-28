Return-Path: <SRS0=lLCO=RD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0810C4360F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 15:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F6922186A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 15:59:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="UvDkHkyB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfB1P7j (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 10:59:39 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41935 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730929AbfB1P7d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 10:59:33 -0500
Received: by mail-lf1-f68.google.com with SMTP id y7so953151lfg.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Feb 2019 07:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/yG045AjHlQzHVMpQbAAWO93fhU+A+guAM3BdQM2REU=;
        b=UvDkHkyBKXzR+vNwnTgp6d1dKeArFVIDTiSvm0o+ynbR3Ot9Whia0CXvVOFxv8JTZj
         ni2AAtm4KeE7NJIZS2cl1+NDoTGqRlT8Lp1qUF+dOYPMYPlkITm+s9OHa/PZMdV6Q1Eo
         yZplS1A4NxRRlsCgL9ZAotfh501RCW1BMcGHM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/yG045AjHlQzHVMpQbAAWO93fhU+A+guAM3BdQM2REU=;
        b=QHNGdi0ganqVnXbpajW5ikS5X7HLsv9WhmZKhrciuEsBPX8MXJsBzrGTedw3kQDHL6
         8aAQCw+rH+1/W4JJV/5eTHwSOFZdLQdO6TiJ81lbPjMRvpn3fYWVm1kqBIFpowP/P5B8
         uxcNiMkvj1WUue16HBlMFFQFE4YqHO5+GuK5QT7I2FPpGIiNzyNbGmiCGOPmgP5MsbxY
         mSE2iEeRS2OVjyyUvkMs7hqoenGqChrK3M+ofSXfE67NAx/qS1V7e7tLRDtnEUNKYXcO
         wOr6moN9fGhIZDAuJUNtW4hSV1nOAItPw4jz4U1hARWrb6eTKO9t49s8v3FpFNAE210c
         kX5w==
X-Gm-Message-State: APjAAAUCm9NEuf2eig4nMvdwJKxSk6Sd1rEmtFmzjzRvw5nygukosAAT
        gGZHDrPKTxkxRYf8PkjovGzBduF5oeFR8USxZC3pTQ==
X-Google-Smtp-Source: APXvYqy8dwHBK38RCZWR3RQyf5zkFEA4bWHqaZ5cTaSdtbqCcr3pbQ75sXR8qJ5d5H7AMvUUltV+PZWS+9Ob9y9h7BE=
X-Received: by 2002:a19:c48a:: with SMTP id u132mr146841lff.16.1551369570963;
 Thu, 28 Feb 2019 07:59:30 -0800 (PST)
MIME-Version: 1.0
References: <20190227193748.132301-1-joel@joelfernandes.org>
 <20190228173444.54403795211d80ba540b61cb@kernel.org> <20190228150054.GB156098@google.com>
 <20190228153026.GG8481@kroah.com> <20190228153741.GA168373@google.com> <20190228154513.GA12050@kroah.com>
In-Reply-To: <20190228154513.GA12050@kroah.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Thu, 28 Feb 2019 07:59:19 -0800
Message-ID: <CAEXW_YRa6bYpHcU-ovvvRYSrTC8JCVwa_wWHe_Krj44ompXroA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>,
        kernel-team <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        linux-kselftest <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Feb 28, 2019 at 7:45 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Feb 28, 2019 at 10:37:41AM -0500, Joel Fernandes wrote:
> > In any case, it is not practical to provide headers for every kernel version on
> > the system image and maintain them, it will take up too much space and has to
> > be periodically packaged. Not to mention that there will be kernel versions
> > that are booting Android that simply don't have anyone maintaining headers
> > for. So the proposed solution is an easier path.
>
> I totally agree with this, and with your proposed patches, just wanting
> to clear up some potential anti-GPL-FUD before it got spread any further :)

Sure, no problem, thanks :)
 - Joel
