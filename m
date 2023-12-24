Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A45D28D
	for <linux-trace-devel@vger.kernel.org>; Sun, 24 Dec 2023 19:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5C1C433C7;
	Sun, 24 Dec 2023 19:01:42 +0000 (UTC)
Date: Sun, 24 Dec 2023 14:01:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Matt Jolly <Matt.Jolly@footclan.ninja>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] Bump meson version to >=0.58.0
Message-ID: <20231224140140.6397e0f3@rorschach.local.home>
In-Reply-To: <20231216015527.167415-1-Matt.Jolly@footclan.ninja>
References: <20231216015527.167415-1-Matt.Jolly@footclan.ninja>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 16 Dec 2023 11:55:27 +1000
Matt Jolly <Matt.Jolly@footclan.ninja> wrote:

> plugins uses str.replace which was introduced in 0.58.0.

Thanks!

I finally have some time to work on the tracing libraries for a bit (of
course it's during the holiday season :-p).

Anyway, when sending patches can you please add to the subject the
project you are sending for.

 Subject: libtraceevent: Bump meson version to >= 0.58.0

As this mailing list supports multiple projects. If the project name
wasn't in the patch itself, I would not have any idea what to apply
this to.

Thanks again for sending the update!

-- Steve


> 
> Signed-off-by: Matt Jolly <Matt.Jolly@footclan.ninja>
> ---
>  meson.build | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/meson.build b/meson.build
> index b61c873..34d3e6d 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -4,7 +4,7 @@
>  
>  project(
>      'libtraceevent', ['c'],
> -    meson_version: '>= 0.50.0',
> +    meson_version: '>= 0.58.0',
>      license: 'LGPL-2.1',
>      version: '1.7.3',
>      default_options: [

