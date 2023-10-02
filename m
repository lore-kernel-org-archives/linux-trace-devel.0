Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504521D685
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 18:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A234C433C7;
	Mon,  2 Oct 2023 18:00:33 +0000 (UTC)
Date: Mon, 2 Oct 2023 14:01:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-trace-devel@vger.kernel.org, Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: Kernelshark: migrate to Qt 6
Message-ID: <20231002140136.6ae97dfc@gandalf.local.home>
In-Reply-To: <9085cbc1-7bf2-38a2-4e4f-1c43c760ce97@redhat.com>
References: <9085cbc1-7bf2-38a2-4e4f-1c43c760ce97@redhat.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 2 Oct 2023 14:22:58 +0200
Jerome Marchand <jmarchan@redhat.com> wrote:

> Hi,
> 
> Qt 5 is reaching end-of-life and Qt 5.15 appears to be the last Qt 5 
> version. Is there any plan to port kernelshark to Qt 6?
> 
> I have no experience with Qt devel, but it seems that some effort has 
> been made to keep the migration easy:
> https://doc.qt.io/qt-6/portingguide.html
> https://www.qt.io/blog/porting-from-qt-5-to-qt-6-using-qt5compat-library
> 

Thanks for notifying us.

Yordan, do you have any time to make the transition to Qt 6?

-- Steve

