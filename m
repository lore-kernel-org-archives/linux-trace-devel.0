Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0C1C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Sep 2021 19:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D71B06127A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Sep 2021 19:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242299AbhI1TDQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Sep 2021 15:03:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242169AbhI1TDQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Sep 2021 15:03:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 799A061206;
        Tue, 28 Sep 2021 19:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632855696;
        bh=kWo6GjDcKnx4SR5tqwzZLP9HAeHoQ7wEpvqH8w9P95I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fczym+eSAuNcaVhTqu8RU9pNq4icfsfFJDmElXtO8xo+Dtx66p0Pf8Fcl+UwAY0gZ
         xHRFqcBNlF+5xsGfU4kpYa1oww2jt3euDprL5Mwc8SjfgPheqcloRZlhXilaHbSG7v
         Y905P0XnQjYctTNWVU+RNTBhkX0N/MEWZbIYaBTkRwXNals/HecyoJW3MUMCRqL4hu
         Z2mNtOjP5Y7OGY1h5U+y3KALA5x154fbe5L+uKTMxJe2cXKYD71HmNg1Bur30QYTRs
         Yj8S4EUNZmFrHeQ6yrsqrFudh+qBp/nYdfgQoa+/rcSFhGPawmaZdII5llZSpVgLRf
         qWMGaijBRHCUw==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 26CD9410A1; Tue, 28 Sep 2021 16:01:34 -0300 (-03)
Date:   Tue, 28 Sep 2021 16:01:34 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, eranian@google.com
Subject: Re: [PATCH v3 1/4] perf: Enable libtracefs dynamic linking
Message-ID: <YVNmjszo792cSutx@kernel.org>
References: <20210923001024.550263-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923001024.550263-1-irogers@google.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Wed, Sep 22, 2021 at 05:10:21PM -0700, Ian Rogers escreveu:
> Currently libtracefs isn't used by perf, but there are potential
> improvements by using it as identified Steven Rostedt's e-mail:
> https://lore.kernel.org/lkml/20210610154759.1ef958f0@oasis.local.home/
> 
> This change is modelled on the dynamic libtraceevent patch by Michael
> Petlan:
> https://lore.kernel.org/linux-perf-users/20210428092023.4009-1-mpetlan@redhat.com/
> 
> v3. Adds file missed in v1 and v2 spotted by Jiri Olsa.

Thanks, applied.

- Arnaldo

 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/build/Makefile.feature          |  1 +
>  tools/build/feature/Makefile          |  4 ++++
>  tools/build/feature/test-libtracefs.c | 10 ++++++++++
>  tools/perf/Makefile.config            |  9 +++++++++
>  tools/perf/Makefile.perf              |  2 ++
>  5 files changed, 26 insertions(+)
>  create mode 100644 tools/build/feature/test-libtracefs.c
> 
> diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
> index 3dd2f68366f9..45a9a59828c3 100644
> --- a/tools/build/Makefile.feature
> +++ b/tools/build/Makefile.feature
> @@ -52,6 +52,7 @@ FEATURE_TESTS_BASIC :=                  \
>          libslang                        \
>          libslang-include-subdir         \
>          libtraceevent                   \
> +        libtracefs                      \
>          libcrypto                       \
>          libunwind                       \
>          pthread-attr-setaffinity-np     \
> diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
> index eff55d287db1..d024b5204ba0 100644
> --- a/tools/build/feature/Makefile
> +++ b/tools/build/feature/Makefile
> @@ -36,6 +36,7 @@ FILES=                                          \
>           test-libslang.bin                      \
>           test-libslang-include-subdir.bin       \
>           test-libtraceevent.bin                 \
> +         test-libtracefs.bin                    \
>           test-libcrypto.bin                     \
>           test-libunwind.bin                     \
>           test-libunwind-debug-frame.bin         \
> @@ -199,6 +200,9 @@ $(OUTPUT)test-libslang-include-subdir.bin:
>  $(OUTPUT)test-libtraceevent.bin:
>  	$(BUILD) -ltraceevent
>  
> +$(OUTPUT)test-libtracefs.bin:
> +	$(BUILD) -ltracefs
> +
>  $(OUTPUT)test-libcrypto.bin:
>  	$(BUILD) -lcrypto
>  
> diff --git a/tools/build/feature/test-libtracefs.c b/tools/build/feature/test-libtracefs.c
> new file mode 100644
> index 000000000000..8eff16c0c10b
> --- /dev/null
> +++ b/tools/build/feature/test-libtracefs.c
> @@ -0,0 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <tracefs/tracefs.h>
> +
> +int main(void)
> +{
> +	struct tracefs_instance *inst = tracefs_instance_create("dummy");
> +
> +	tracefs_instance_destroy(inst);
> +	return 0;
> +}
> diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
> index 446180401e26..00ec900ddbca 100644
> --- a/tools/perf/Makefile.config
> +++ b/tools/perf/Makefile.config
> @@ -1098,6 +1098,15 @@ ifdef LIBTRACEEVENT_DYNAMIC
>    endif
>  endif
>  
> +ifdef LIBTRACEFS_DYNAMIC
> +  $(call feature_check,libtracefs)
> +  ifeq ($(feature-libtracefs), 1)
> +    EXTLIBS += -ltracefs
> +  else
> +    dummy := $(error Error: No libtracefs devel library found, please install libtracefs-dev);
> +  endif
> +endif
> +
>  # Among the variables below, these:
>  #   perfexecdir
>  #   perf_include_dir
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index e04313c4d840..7df13e74450c 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -130,6 +130,8 @@ include ../scripts/utilities.mak
>  #
>  # Define LIBTRACEEVENT_DYNAMIC to enable libtraceevent dynamic linking
>  #
> +# Define LIBTRACEFS_DYNAMIC to enable libtracefs dynamic linking
> +#
>  
>  # As per kernel Makefile, avoid funny character set dependencies
>  unexport LC_ALL
> -- 
> 2.33.0.464.g1972c5931b-goog

-- 

- Arnaldo
