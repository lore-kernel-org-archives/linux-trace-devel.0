Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A193626296
	for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2024 20:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC13BC433F1;
	Wed, 10 Jan 2024 20:55:28 +0000 (UTC)
Date: Wed, 10 Jan 2024 15:56:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Giulio Benetti <giulio.benetti@benettiengineering.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs meson: build tracefs-mmap by default
Message-ID: <20240110155629.05345bc8@gandalf.local.home>
In-Reply-To: <20240110203925.266999-1-giulio.benetti@benettiengineering.com>
References: <20240110203925.266999-1-giulio.benetti@benettiengineering.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 10 Jan 2024 21:39:25 +0100
Giulio Benetti <giulio.benetti@benettiengineering.com> wrote:

> Accordingly to Makefile let's add tracefs-mmap.c to build, this is needed
> for linking by other object files.
> 
> Signed-off-by: Giulio Benetti <giulio.benetti@benettiengineering.com>

Bah! I need to start remembering to update the meson.build file when adding
new files.

Thanks for the change. It'll go into 1.8.1 which I'll wait till next week
to see what else may have broken.

-- Steve

> ---
>  src/meson.build | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/src/meson.build b/src/meson.build
> index 5b76554..f7a98b9 100644
> --- a/src/meson.build
> +++ b/src/meson.build
> @@ -11,6 +11,7 @@ sources= [
>     'tracefs-instance.c',
>     'tracefs-kprobes.c',
>     'tracefs-marker.c',
> +   'tracefs-mmap.c',
>     'tracefs-record.c',
>     'tracefs-sqlhist.c',
>     'tracefs-tools.c',

