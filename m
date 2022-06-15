Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E3EC43334
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jun 2022 15:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiFOPpr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 Jun 2022 11:45:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42672 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiFOPpr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Jun 2022 11:45:47 -0400
Received: from [172.19.1.40] (not.afront.org [50.126.75.182])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 116D4840E2BF;
        Wed, 15 Jun 2022 08:45:47 -0700 (PDT)
Message-ID: <05953c51-7139-f9ef-ed43-ecc2530bd071@eaglescrag.net>
Date:   Wed, 15 Jun 2022 08:45:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] trace-cruncher: Enable Github development flow
Content-Language: en-US
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org
References: <20220615151558.226641-1-tz.stoyanov@gmail.com>
From:   John 'Warthog9' Hawley <warthog9@eaglescrag.net>
In-Reply-To: <20220615151558.226641-1-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 15 Jun 2022 08:45:47 -0700 (PDT)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 6/15/2022 8:15 AM, Tzvetomir Stoyanov (VMware) wrote:
> Github development flow is more popular among python developers. The
> CONTRIBUTING file is updated to enable both mailing list based (current
> one) and PR based (github) development flows. The main motivation for
> this change in to attract more contributors.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>

This looks fine to me, and will be interesting to see how this ends up 
working out.

- John 'Warthog9' Hawley

> ---
>   CONTRIBUTING.md | 26 +++++++++++++++-----------
>   1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
> index 865fcc8..c22780b 100644
> --- a/CONTRIBUTING.md
> +++ b/CONTRIBUTING.md
> @@ -5,21 +5,25 @@
>   The trace-cruncher project team welcomes contributions from the community. All contributions to this repository must be
>   signed. Your signature certifies that you wrote the patch or have the right to pass it on as an open-source patch.
>   
> -The development process of trace-cruncher is strongly coupled to the development of the Linux kernel tracing libraries [libtraceevent](https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git), [libtracefs](https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/) and [KernelShark](https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/). Because of this reason we adopt and follow the development workflow established by those projects.
> +### Submitting patches
>   
> -For contributions to development, please send patches to: linux-trace-devel@vger.kernel.org
> +Patches can be submitted by either:
> + 1. Using the regular [Github Flow](https://docs.github.com/en/get-started/quickstart/github-flow):
> +    - The main branch is **tracecruncher**.
> +    - Any changes must be on a feature branch or on a fork.
> +    - Tests must pass before merging, and the pull request must be [reviewed](https://docs.github.com/en/github/collaborating-with-pull-requests/reviewing-changes-in-pull-requests) and approved.
> +    - Break the complex Pull Requests into small self-contained patches.
>   
> -[Subscribe](http://vger.kernel.org/vger-lists.html#linux-trace-devel) / [Archives](https://lore.kernel.org/linux-trace-devel/)
> + 2. Using the [Linux kernel](https://www.kernel.org/doc/html/v5.4/process/submitting-patches.html) development workflow:
> +    - Add prefix "trace-cruncher:" to the patch subject.
> +    - Break the changes into small self-contained patches and group them in a patch set.
> +    - Send patches to linux-trace-devel@vger.kernel.org
> +    - [Subscribe](http://vger.kernel.org/vger-lists.html#linux-trace-devel) / [Archives](https://lore.kernel.org/linux-trace-devel/)
>   
>   ### Code Style
>   
>   The preferred coding style for the project is the [Linux kernel coding style](https://www.kernel.org/doc/html/v4.10/process/coding-style.html#linux-kernel-coding-style)
>   
> -### Formatting Commit Messages
> -
> -The project follows the conventions for [submitting patches](https://www.kernel.org/doc/html/v5.4/process/submitting-patches.html)
> -as described by the Linux kernel.
> -
>   ### Tests
>   
>   Make sure that all your changes are covered by the tests. Before submitting your patch, check if everything works at 100% by running the tests in **tracecruncher/tests**. Compile your changes and install trace-cruncher (`sudo make install`), to make sure that your code is used in the tests. As trace-cruncher interacts with the Linux kernel tracing infrastructure, the tests must be run with root privileges:
> @@ -30,6 +34,6 @@ sudo python3 -m unittest discover .
>   ```
>   
>   ## Reporting Bugs and Creating Issues
> -For bug reports and issues, please file it [bugzilla](https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&product=Tools&resolution=---)
> -
> -When opening a new issue, try to roughly follow the commit message format conventions above.
> +Bug reports and issues can be submitted by either:
> +1. Create a [Github issue](https://docs.github.com/es/issues/tracking-your-work-with-issues/creating-an-issue) in [trace-cruncher](https://github.com/vmware/trace-cruncher).
> +2. Report them in [bugzilla](https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&product=Tools&resolution=---), **Tools and utilities** category, **Trace-cmd and kernelshark** component.
