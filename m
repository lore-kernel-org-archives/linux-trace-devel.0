Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EACA538B
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jan 2024 05:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF37C433C9;
	Fri,  5 Jan 2024 05:15:33 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rLcZU-00000000xXY-1q5c;
	Fri, 05 Jan 2024 00:16:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] libtracefs: Add more tracefs_sql tests
Date: Fri,  5 Jan 2024 00:15:37 -0500
Message-ID: <20240105051639.228850-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

I found that tracefs_sql() had some broken features. Add tests that would
have caught that the features were broken!

Steven Rostedt (Google) (2):
  libtracefs utest: Add matches to trace_sql() tests
  libtracefs utest: Add more tests to test tracefs_sql()

 utest/tracefs-utest.c | 369 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 367 insertions(+), 2 deletions(-)

-- 
2.42.0

