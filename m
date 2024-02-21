Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06272A35
	for <linux-trace-devel@vger.kernel.org>; Wed, 21 Feb 2024 23:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708559270; cv=none; b=c+jW6ZQ7a7KRq8l6xUfE9VEbBi740UfhdhRxDQ01NaF8qNpN9GXaR1yb642HKIYUyJ6OHuth8CP951uEux/eUmQkjc/1A+Q3dqG6yZeOc2o8vz/DsswYrPBi8n8ks9e9bOKbU7LI79AZmBWfWpPpALFHG224BTLaBsfM5FIa2/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708559270; c=relaxed/simple;
	bh=K2TS9pes5sc077e8eiycA5OCgy8owl8WkqMxc1xXle8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rzxm7BhDeCwCslXGzQvSFUwjjJySFg90zzPssNtEuPo5Wk4vkPliZ+/C/1w7ljxpEJb7ZgTEzcwXGzIHqhb0xWtUaZhkho7q4vGsOK9MQeo9TivKAtHosxuHK/e3I9T2J6hXPiRPOJ4t+9SbEWnNEntU04aBum7xpbJRcjo454g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2319AC433F1;
	Wed, 21 Feb 2024 23:47:49 +0000 (UTC)
Date: Wed, 21 Feb 2024 18:49:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Miko Larsson via B4 Relay <devnull+mikoxyzzz.gmail.com@kernel.org>
Cc: <mikoxyzzz@gmail.com>, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] utest/tracefs-utest: add missing define
Message-ID: <20240221184937.64d71df0@gandalf.local.home>
In-Reply-To: <20240215-utest-fixes-v1-2-24678d859de2@gmail.com>
References: <20240215-utest-fixes-v1-0-24678d859de2@gmail.com>
	<20240215-utest-fixes-v1-2-24678d859de2@gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Feb 2024 10:02:42 +0100
Miko Larsson via B4 Relay <devnull+mikoxyzzz.gmail.com@kernel.org> wrote:

> From: Miko Larsson <mikoxyzzz@gmail.com>
> 
> Fixes FTBFS with clang >=15

FTBFS is a rather useless explanation (and I had to even look it up to find
out what it is ;-)

The change log should show the error and explain why the change fixes the
problem.

Thanks,

-- Steve


> 
> Fixes: 0f45e68cb04a ("libtracefs: Add unit tests for tracefs_cpu functions")
> Signed-off-by: Miko Larsson <mikoxyzzz@gmail.com>
> ---
>  utest/tracefs-utest.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
> index a798ace..e30e8e7 100644
> --- a/utest/tracefs-utest.c
> +++ b/utest/tracefs-utest.c
> @@ -3,6 +3,8 @@
>   * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
>   *
>   */
> +#define _LARGEFILE64_SOURCE
> +
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <sys/stat.h>
> 

