Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3004A35
	for <linux-trace-devel@vger.kernel.org>; Wed, 21 Feb 2024 23:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708559176; cv=none; b=tbRtfJmuo/kQq+LJsMrtaeIJlg8ERku1BeLkJZelDpBvH8iZSHZtSgELb+jW6pUiLd+F/58cWzdgaaqLTU8Sq86SePqoQ+/mPqJvq5+LxkWc2Nvu7fO5QOJiXWMym4Ffnwy0jwxL0WAkKbTDV/CyZNCDuSxeJcND8O0xc4lNYKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708559176; c=relaxed/simple;
	bh=Uqnegv6ZWO5Edz92O6FBzY7EiwuWsNc8zsCbZUoTwlk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bag2L5dsToC7df+sr+Y3YCZ7OWbULoTqrN6+10T0a+EJPqExjncP1p1lK10ZPBuwG5u58rOiU1QeZGvIMq+5vpPMOC6YXdkUIT76WVg/00qELXb6eP9NWDo6yxfu73QV083KkPMiq1pPcQSt0ZZ6iFS5JmxlLPHLE+uTyGzuEuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FE2C433F1;
	Wed, 21 Feb 2024 23:46:14 +0000 (UTC)
Date: Wed, 21 Feb 2024 18:48:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Miko Larsson via B4 Relay <devnull+mikoxyzzz.gmail.com@kernel.org>
Cc: <mikoxyzzz@gmail.com>, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/3] utest/tracefs-utest: add missing include
Message-ID: <20240221184803.3fcc5455@gandalf.local.home>
In-Reply-To: <20240215-utest-fixes-v1-1-24678d859de2@gmail.com>
References: <20240215-utest-fixes-v1-0-24678d859de2@gmail.com>
	<20240215-utest-fixes-v1-1-24678d859de2@gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Feb 2024 10:02:41 +0100
Miko Larsson via B4 Relay <devnull+mikoxyzzz.gmail.com@kernel.org> wrote:

> From: Miko Larsson <mikoxyzzz@gmail.com>

Hi Miko,

> 
> Fixes FTBFS with clang >=15

What exactly is this fixing. I tried building the tests with clang 16 and I
don't get any errors. Please show the error that you have without this
change.

-- Steve

 
> 
> Fixes: 845f16976929 ("libtracefs: Add unit tests")
> Signed-off-by: Miko Larsson <mikoxyzzz@gmail.com>
> ---
>  utest/tracefs-utest.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
> index 963fac7..a798ace 100644
> --- a/utest/tracefs-utest.c
> +++ b/utest/tracefs-utest.c
> @@ -19,6 +19,8 @@
>  #include <sys/mount.h>
>  #include <sys/syscall.h>
>  
> +#include <linux/limits.h>
> +
>  #include <CUnit/CUnit.h>
>  #include <CUnit/Basic.h>
>  
> 

