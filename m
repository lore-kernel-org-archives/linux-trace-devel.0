Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C6117E2
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Dec 2023 03:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19419C433C7;
	Fri, 29 Dec 2023 03:18:18 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rJ3Ou-00000000I4Y-23OM;
	Thu, 28 Dec 2023 22:19:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/4] trace-cmd: Add ways to read more tracefs files
Date: Thu, 28 Dec 2023 22:16:43 -0500
Message-ID: <20231229031907.69432-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Update trace-cmd show and stat to display more tracefs information:

 trace-cmd show --buffer-subbuf-size
 trace-cmd show --buffer_percent

And use tracefs_instance_file_read() instead of open coding it in
trace-cmd stat.

Steven Rostedt (Google) (4):
  trace-cmd show: Re-arrange the enum long option values
  trace-cmd show: Add --buffer-subbuf-size option
  trace-cmd show: Add option to read buffer_percent
  trace-cmd stat: Use tracefs_instance_file_read()

 Documentation/trace-cmd/trace-cmd-show.1.txt | 13 ++++++
 tracecmd/trace-show.c                        | 32 +++++++++-----
 tracecmd/trace-stat.c                        | 45 ++++----------------
 tracecmd/trace-usage.c                       |  2 +
 4 files changed, 45 insertions(+), 47 deletions(-)

-- 
2.42.0
