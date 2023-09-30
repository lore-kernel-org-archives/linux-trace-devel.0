Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED26156DF
	for <linux-trace-devel@vger.kernel.org>; Sat, 30 Sep 2023 20:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410E7C433C8;
	Sat, 30 Sep 2023 20:39:12 +0000 (UTC)
Date: Sat, 30 Sep 2023 16:39:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Giulio Benetti <giulio.benetti@benettiengineering.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: add option to disable documentation
Message-ID: <20230930163900.152d49fd@rorschach.local.home>
In-Reply-To: <ce8cac08-58be-4221-b5ab-fde7f9aab2bd@benettiengineering.com>
References: <20230930201339.2525344-1-giulio.benetti@benettiengineering.com>
	<20230930162825.4f8544c3@rorschach.local.home>
	<ce8cac08-58be-4221-b5ab-fde7f9aab2bd@benettiengineering.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 30 Sep 2023 22:32:52 +0200
Giulio Benetti <giulio.benetti@benettiengineering.com> wrote:

> Hi Steve,
> 
> On 30/09/23 22:28, Steven Rostedt wrote:
> > On Sat, 30 Sep 2023 22:13:39 +0200
> > Giulio Benetti <giulio.benetti@benettiengineering.com> wrote:
> > 
> > Hi Giulio,
> > 
> > Thanks for the patch, but could you please add a change log to explain
> > why this patch is needed? I'm not saying it isn't but I'd like to know
> > the rational for disabling documentation.  
> 
> Sure, same for libtracefs then.
> 
> Would it be possible to release a minor version after committing?
> This is because I've updated libtraceevent, libtracefs and trace-cmd in
> buildroot but without using meson due to asciidoc not found(in Buildroot
> we never produce documentation for target).

Sure, it's time for me to start working on the user space libraries
again anyway (I toggle my time between the kernel and user space
tracing).

> 
> So if you could release new versions of libtraceevent and libtracefs
> after committing V2 patches I could bump in Buildroot and use meson
> that is very clean compared to the actual Makefile custom build calls.
> 
> Going to send V2 patches in the meanwhile.
> 
> Best regards

Appreciated!

-- Steve
