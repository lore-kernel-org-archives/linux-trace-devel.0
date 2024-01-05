Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D621CA9F
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jan 2024 05:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65649C433C9;
	Fri,  5 Jan 2024 05:20:35 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rLceM-00000000xZo-33lD;
	Fri, 05 Jan 2024 00:21:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] libtracefs sql: A couple of fixes
Date: Fri,  5 Jan 2024 00:20:59 -0500
Message-ID: <20240105052141.228999-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Found a couple of bugs in tracefs_sql(). These fix them.

Steven Rostedt (Google) (2):
  libtracefs synthetic: Remove multiple adding of action in
    tracefs_synth_save()
  libtracefs synthetic: Handle hashed name variables

 src/tracefs-hist.c | 82 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 70 insertions(+), 12 deletions(-)

-- 
2.42.0

