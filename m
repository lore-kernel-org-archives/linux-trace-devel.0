Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19357C43334
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Jun 2022 15:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240531AbiFMPwG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Jun 2022 11:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240968AbiFMPvn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Jun 2022 11:51:43 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0551862B4
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Jun 2022 06:37:00 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id k4so5905181vsp.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Jun 2022 06:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4AJ9qzlNh/3mf/VPJUC6PZhERHe/YfqFjQWiY9scyI4=;
        b=acoGAGhisRFFvWz/UJbo/pDpdza1toL1vNQAkP1IZmq4mnMuwqLlpYpP9LUqTkcBK4
         T586Qo3QNw7sOUXppEK8iSJGjctm7bK2Tgu6bWJJKeAtQ0E8yqRN1pXbeluZWZqzfDFt
         f672+R+D1BTtUJLQ3oVxK9QnTrxGOGhu3WUL+QEHAB2CaLA58Kh/CooH6IgVYk9r2mDd
         JeGyjv7B8MZkXt32ueqyjI4OW0HB7+R4azhPpQQfeZaILFuFEKZjnaZQ8/6Jt6OMvltF
         7tNWxrNlYlh3uyLnYr+4mZA86h3NpQkjxgXK6vYGpha9SLaMVVILdyvOltd6VTaRoFbo
         f+Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4AJ9qzlNh/3mf/VPJUC6PZhERHe/YfqFjQWiY9scyI4=;
        b=GAWghR38W+Z9lOSGxzggbML7MhVa/bbZ7yFSSYDvpkfKiaLD98zI5iJLtxX86tyxRZ
         7vbGf7q9ZyKAcLWzKNS74Zk2M8uC6tDc/jSH+ja03Lm6WuqvwF0plXmgXJDHC7WTb8Th
         H9lWHTbJbYMTDeEnU9ZPS4JRPVuqI82aJyUTJO1zbx0Ev4o9EqVhwCXNfuWTlEbyVtVz
         3bGdbZtsWWe9oYqWMIog9DbLAvYTHqt6gFGUyRQI28GcbICh4o/MLwIcJd5YNGLU7XS0
         WlJBtKpETxHHA/A3Lu0umQIZRM+174lGNUdP7JMz89RYG+favKheQd9T2I4d/YuaD3o7
         fb2A==
X-Gm-Message-State: AOAM533NE0m2cev/k20mWoIZxAFtYLF4Z+1iALg/WNr7LLtF9IllOv4F
        +LR1EPHQbwiSchlktbFrEVV3H2lc2HDpufaKuItGclhc7dM=
X-Google-Smtp-Source: ABdhPJx2OZYy/Ab/eP6ktIR5gM55vQ9ORYXd0LSajPsBdtxoW6ay2Ok/R829NrNghmR6If2RdffFHdfxiU0H/Xxw8no=
X-Received: by 2002:a67:1943:0:b0:34b:8b6a:2329 with SMTP id
 64-20020a671943000000b0034b8b6a2329mr24391617vsz.5.1655127419173; Mon, 13 Jun
 2022 06:36:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220610225554.5275-1-june.knauth@gmail.com>
In-Reply-To: <20220610225554.5275-1-june.knauth@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 13 Jun 2022 16:36:43 +0300
Message-ID: <CAPpZLN48wyThO3bRY90azMD5w_po2TpASoUss6HXqjwqMi4zOQ@mail.gmail.com>
Subject: Re: [PATCH] trace-cruncher: README updates; add Testing, reformat,
 and fix deps
To:     June Knauth <june.knauth@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Jun 11, 2022 at 2:07 AM June Knauth <june.knauth@gmail.com> wrote:
>
> From: "June Knauth (VMware)" <june.knauth@gmail.com>
>
> This patch covers several small improvements in the README. They are:
> 1. Removal of the > characters and excess linebreaks to improve readability
> 2. Addition of two dependencies to the manual install instructions:
> binutils-dev and pkg-config.
> 3. Addition of a "Testing" section

Hi June,
"Testing" is described in the CONTRIBUTING file, as it is more related
to the development process, but I agree that it is useful to have it
in the  README as well.
Applied.
Thanks for polishing the documentation!

>
> Signed-off-by: June Knauth (VMware) <june.knauth@gmail.com>
> ---
>  README.md | 104 +++++++++++++++++++++---------------------------------
>  1 file changed, 40 insertions(+), 64 deletions(-)
>
> diff --git a/README.md b/README.md
> index 95cbd8e..cba5495 100644
> --- a/README.md
> +++ b/README.md
> @@ -17,83 +17,59 @@ Trace-Cruncher has the following external dependencies:
>
>  1.1 In order to install all packages on Ubuntu do the following:
>
> -    > sudo apt-get update
> -
> -    > sudo apt-get install build-essential git cmake libjson-c-dev -y
> -
> -    > sudo apt-get install libpython3-dev cython3 python3-numpy python3-pip -y
> -
> -    > sudo apt-get install flex valgrind -y
> -
> -    > sudo pip3 install --system pkgconfig GitPython
> +    sudo apt-get update
> +    sudo apt-get install build-essential git cmake libjson-c-dev -y
> +    sudo apt-get install libpython3-dev cython3 python3-numpy python3-pip -y
> +    sudo apt-get install flex valgrind binutils-dev pkg-config -y
> +    sudo pip3 install --system pkgconfig GitPython
>
>  1.2 In order to install all packages on Fedora, as root do the following:
>
> -    > sudo dnf install gcc gcc-c++ git cmake json-c-devel -y
> -
> -    > sudo dnf install python3-devel python3-Cython python3-numpy python3-pip -y
> -
> -    > sudo dnf install flex valgrind -y
> -
> -    > sudo pip3 install --system pkgconfig GitPython
> -
> +    sudo dnf install gcc gcc-c++ git cmake json-c-devel -y
> +    sudo dnf install python3-devel python3-Cython python3-numpy python3-pip -y
> +    sudo dnf install flex valgrind -y
> +    sudo pip3 install --system pkgconfig GitPython
>
>  2 In order to install all third party libraries do the following:
>
> -    > git clone https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
> -
> -    > cd libtraceevent
> -
> -    > make
> -
> -    > sudo make install
> -
> -    > cd ..
> -
> -
> -    > git clone https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
> -
> -    > cd libtracefs
> -
> -    > make
> -
> -    > sudo make install
> -
> -    > cd ..
> -
> -
> -    > git clone https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
> -
> -    > cd trace-cmd
> -
> -    > make
> -
> -    > sudo make install_libs
> -
> -    > cd ..
> -
> -
> -    > git clone https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/
> -
> -    > cd kernel-shark/build
> -
> -    > cmake ..
> -
> -    > make
> -
> -    > sudo make install
> -
> -    > cd ../..
> +    git clone https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
> +    cd libtraceevent
> +    make
> +    sudo make install
> +    cd ..
> +
> +    git clone https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
> +    cd libtracefs
> +    make
> +    sudo make install
> +    cd ..
> +
> +    git clone https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
> +    cd trace-cmd
> +    make
> +    sudo make install_libs
> +    cd ..
> +
> +    git clone https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/
> +    cd kernel-shark/build
> +    cmake ..
> +    make
> +    sudo make install
> +    cd ../..
>
>  ### Build & Run
>
>  Installing trace-cruncher is very simple. After downloading the source code, you just have to run:
>
> -     > cd trace-cruncher
> +    cd trace-cruncher
> +    make
> +    sudo make install
> +
> +### Testing
>
> -     > make
> +To execute the unit tests run the following from the `trace-cruncher/tests` directory:
>
> -     > sudo make install
> +       sudo python3 -m unittest discover .
>
>  ## Documentation
>  For questions about the use of Trace-Cruncher, please send email to: linux-trace-users@vger.kernel.org
> --
> 2.25.1
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
