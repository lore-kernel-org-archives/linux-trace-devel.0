Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88EED66;
	Tue, 28 Nov 2023 11:24:47 -0800 (PST)
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-67a4405c5d5so14090866d6.1;
        Tue, 28 Nov 2023 11:24:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701199486; x=1701804286;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pS8AM0GRPJNZya3U1nEdnkoY2lKxS69IuJjwqW9TK3g=;
        b=ZMwZy+wD0szSnMjeAuPfH/tNm/bTpzvhMh8c5nI/ebPSKDKD8KW7YkIgvw//vg/wtX
         Z8l4tki6Mj+Osit1P9qBBXPyd+VURNALrW7ll7loKO7or/GfkeVvGO0epsXc6lmjzyEi
         rK4Cb06uTKF85aDTIWlDhTH0C7J0tHxLoVNUpAdoGyfakDloLRN8nh3Od/uXoni2KqdV
         8E8MU/N9newHTZkT8dB7uuyjRlpoEgc9TOLKBOwysMm2koL+kSdrthslbih8bWLJcJH1
         Ab42tmKWwsjVqVfQsNh2geobjVt50ipYY9zcw+RSVuufS5zPDdqgZ1FdFkdK9B+Oj6sq
         V62w==
X-Gm-Message-State: AOJu0YwFWxp1E0zoFp7u6YGgEL6/cH426WE4YartyQ+8FPl1syiXqqA6
	Nu7ymzmobV0YigxpLQP1HrL0DF8au1g85Xq1
X-Google-Smtp-Source: AGHT+IF+7Ua/UlK3YN12Y4VhvSs9oURkXDZ8+S30CKsU5l2Vd75ZyUfAUVn7NVt32xyeDKH1RGQ/Zg==
X-Received: by 2002:a0c:ecd0:0:b0:67a:3757:880c with SMTP id o16-20020a0cecd0000000b0067a3757880cmr10426739qvq.40.1701199486438;
        Tue, 28 Nov 2023 11:24:46 -0800 (PST)
Received: from localhost (c-24-1-27-177.hsd1.il.comcast.net. [24.1.27.177])
        by smtp.gmail.com with ESMTPSA id m5-20020ad45045000000b0067835abc38bsm4157014qvq.129.2023.11.28.11.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 11:24:46 -0800 (PST)
From: David Vernet <void@manifault.com>
To: linux-trace-devel@vger.kernel.org
Cc: linux-trace-users@vger.kernel.org,
	rostedt@goodmis.org,
	kernel-team@meta.com,
	julia.lawall@inria.fr,
	himadrispandya@gmail.com
Subject: [PATCH] trace-cmd record: Reset PATH variable after strtok search
Date: Tue, 28 Nov 2023 13:24:35 -0600
Message-ID: <20231128192435.36507-1-void@manifault.com>
X-Mailer: git-send-email 2.42.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

execute_program(), in the trace-cmd record subcommand, searches for a
command in PATH to create an absolute path to pass to execve. The
implementation uses strtok_r, which mutates the underlying string in
place by replacing ':' tokens with NULL bytes. This can and does cause
the PATH that's passed to execve to only contain the first entry to
PATH, which can cause issues such as the following:

[root@maniforge linus]# trace-cmd record -e sched -v -e sched_stat_runtime make clean
/bin/sh: line 1: uname: command not found
/bin/sh: line 1: sed: command not found
/bin/sh: line 1: head: command not found
/bin/sh: line 1: grep: command not found
/bin/sh: line 1: mkdir: command not found
...
/bin/sh: line 1: mkdir: command not found
/bin/sh: line 1: mkdir: command not found
Makefile:681: arch//Makefile: No such file or directory
make: *** No rule to make target 'arch//Makefile'.  Stop.

We should be resetting the PATH variable to the string stored in the
saveptr argument to strtok_r.

Fixes: edf9424029cc ("trace-cmd: Open code execvp routine to avoid multiple execve syscalls")
Signed-off-by: David Vernet <void@manifault.com>
---
 tracecmd/trace-record.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index bced80406816..63af11ecaa80 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -1708,6 +1708,14 @@ static void execute_program(int argc, char **argv)
 				break;
 
 		}
+
+		/*
+		 * reset PATH to saveptr, as strtok_r overwrites the string
+		 * returned by getenv() which backs the PATH environment
+		 * variable.
+		 */
+		if (setenv("PATH", saveptr, 1))
+			die("Failed to reset PATH to %s (%s)", saveptr, strerror(errno));
 	} else {
 		strncpy(buf, argv[0], sizeof(buf));
 	}
-- 
2.42.1

