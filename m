Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA084654D
	for <linux-trace-devel@vger.kernel.org>; Mon,  8 Jan 2024 19:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11474C433C7;
	Mon,  8 Jan 2024 19:31:27 +0000 (UTC)
Date: Mon, 8 Jan 2024 14:32:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Giulio Benetti <giulio.benetti@benettiengineering.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] libtracefs: add option to disable documentation
Message-ID: <20240108143224.31b811d4@gandalf.local.home>
In-Reply-To: <e5837824-0f3c-4ae5-918e-cf78dd5f3896@benettiengineering.com>
References: <20230930204008.2528607-1-giulio.benetti@benettiengineering.com>
	<e5837824-0f3c-4ae5-918e-cf78dd5f3896@benettiengineering.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 6 Jan 2024 13:41:12 +0100
Giulio Benetti <giulio.benetti@benettiengineering.com> wrote:

> Hi Steven,
> 
> would it be possible to commit this change before releasing new version?
> This way I can add both libtracefs and libtraceevent without local
> patches as you can see on this iteration to bump trace-cmd:
> https://patchwork.ozlabs.org/project/buildroot/list/?series=379077
> 
> The same patch has been committed to libtraceevent:
> https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/commit/?id=5b893850d20f8e4377dcdf66089d60e2559b4b26
> 
> Best regards

Strange, patchwork had this as "Accepted", but it wasn't. Which would hide
it from me. :-/

Not sure how that happened. Thanks for letting me know. I'll add it now.

-- Steve
